Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYHMPGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYHMPGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYHMPF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:05:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:38962 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYHMPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Uu8eyKNAJmPl0nb1qmoCYSjcngPEdl/HgKabpJrPWXcaVBsie5A3qewg7NPhFEjvvS
         zRLCdMkUGxodefBNslwc0XzjuP9J/7Db/jUQL+uhJHv7/L01tSepq5U4pXVKzX9FQwbC
         FVkCc47mfKKfh/J3UV24JTDlFKeIzJ11nU1K8=
Message-ID: <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>
Date: Thu, 14 Aug 2008 00:05:54 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       andi@firstfloor.org, "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48A2F030.9080301@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48986AC6.5030406@linux-foundation.org>
	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48A2DD2C.3090602@linux-foundation.org>
	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
	 <48A2F030.9080301@linux-foundation.org>
X-Google-Sender-Auth: f5578481b80f273b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes but running with this patch would allow us to verify that we understand
> what is causing the problem. There are other solutions like skipping to the
> next partial slab on the list that could fix performance issues that the patch
> may cause. A test will give us:
>
> 1. Confirmation that the memory use is caused by the trylock.
>
> 2. Some performance numbers. If these show a regression then we have some
> markers that we can measure other solutions against.

okey.
I will confirm its patch at next week.

(unfortunately, my company don't business in rest this week)

Thanks.

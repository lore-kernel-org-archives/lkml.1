Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYHDQrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYHDQrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHDQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:47:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:34005 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYHDQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LsbXN4OiKIkqoEngqZ7OKsmG69iVR0GG9z1YpdwIeu9DCed1dCLXzKLLAMmaEunzC7
         7+Q7PxBLkVlz9CVrydmIZcmSflv7hH5QtFUHfeSRwSW9w5kK/15YZH2dybbmcmRtklca
         j8WJRmflRyJverlTCN1taqCXbjUbk2XSNQ+4o=
Message-ID: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com>
Date: Tue, 5 Aug 2008 01:47:42 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       andi@firstfloor.org, "Rik van Riel" <riel@redhat.com>,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <48970779.80902@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801182324.572058187@lameter.com>
	 <20080803015847.GD26461@parisc-linux.org>
	 <48970779.80902@linux-foundation.org>
X-Google-Sender-Auth: ea3b1bb040504ad9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Could you address the performance issues in different ways? F.e. try to free
> when the object is hot or free from multiple processors? SLAB has to take the
> list_lock rather frequently under high concurrent loads (depends on queue
> size). That will not occur with SLUB. So you actually can free (and allocate)
> concurrently with high performance.

just information. (offtopic?)

When hackbench running, SLUB consume memory very largely than SLAB.
then, SLAB often outperform SLUB in memory stavation state.

I don't know why memory comsumption different.
Anyone know it?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYLZEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYLZEST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 23:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYLZESJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 23:18:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:36013 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYLZESI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 23:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lw3lXYqBGWHL+GiCbB/YO4E3gN0q47niofmn/Vg3TNMd2hoigOuzK83JYR8vFTOxe7
         nDVANTt+eHf6ss2E8rhHDJ2c5oYnd3QgXdQMRlM09c2JTFUmLVVMOvO5skW9o5pbdb5C
         JCrLqrhIHgXnHCFP+HrEtVVLVV9IUvwwP8FDE=
Message-ID: <86802c440812252018w3919614fwaf591aa1e93d2085@mail.gmail.com>
Date: Thu, 25 Dec 2008 20:18:07 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081226122422.5CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081226122422.5CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 9345545a63e17aaf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 7:28 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> Impact: cleanup
>
> introduce irq_inuse() macro and remove ifdef in stat.c

should have a good name... irq_inuse is some confusing.

YH

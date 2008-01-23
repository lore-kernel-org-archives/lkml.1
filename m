Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYAWMQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYAWMQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYAWMQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:16:05 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:50357 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYAWMQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ljeOhAhuxE/U5Yz8jBqkxCtXZJYvI0w2JUWymbRppUkJuS4bZ2YzQWKDsfV5VUc6eftsBDX18+3SONrno5RcaE58s4pnvzef/7MR8EzcJsaH+wwrOB4kMx87E2QQq/mWKeJP5c0Gb+ICiW28i8KDCtyuvqgBjkDvzTlizyWicd4=
Message-ID: <386072610801230416v4ecb364aqe69a7e3ec95a8161@mail.gmail.com>
Date: Wed, 23 Jan 2008 20:16:01 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] procfs: constify function pointer tables
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Bryan Wu" <bryan.wu@analog.com>, "Mikael Starvik" <starvik@axis.com>,
       "David Howells" <dhowells@redhat.com>,
       "Hirokazu Takata" <takata@linux-m32r.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kyle McMartin" <kyle@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, "Chris Zankel" <chris@zankel.net>
In-Reply-To: <Pine.LNX.4.64.0801231224180.12676@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
	 <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
	 <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com>
	 <Pine.LNX.4.64.0801231005090.12676@fbirervta.pbzchgretzou.qr>
	 <386072610801230241h750ea592h9658b14fd2aa7058@mail.gmail.com>
	 <Pine.LNX.4.64.0801231224180.12676@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 7:25 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 23 2008 18:41, Bryan Wu wrote:
> >Oh, this patch does not touch all, following is the missing list:
> >---
> [...]
> >arch/ia64/hp/common/sba_iommu.c:static struct seq_operations ioc_seq_ops = {
> >arch/ia64/kernel/perfmon.c:struct seq_operations pfm_seq_ops = {
> >arch/ia64/kernel/setup.c:struct seq_operations cpuinfo_op = {
> >arch/ia64/sn/kernel/sn2/sn2_smp.c:static struct seq_operations
> (and more)
> [...]
>
> They were sent as other separate patches to each maintainer.
> (without lkml, would have been a needless patchbomb.)
>

Oh, don't know that. I worried a lot, -:))

-Bryan

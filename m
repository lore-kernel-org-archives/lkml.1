Return-Path: <linux-kernel-owner+w=401wt.eu-S1030395AbXBZSNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395AbXBZSNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030397AbXBZSNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:13:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:57224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030395AbXBZSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qokY9BMCojabmsxDdZARkaVJTUc8s2pueC265WAVPyPP/5CfPJyBXF1inBZOewBYvFOCAZl3UoqcDMcGi7W0H0ivJ9aPP+0ZEiabaBBl3tP75gRjbm9kMMyRLSiZiXJHwPC8tRuKba4mqPf0QAckHAjuESpxuP/r7Al88wbRwhs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [git patches] more IDE updates
Date: Mon, 26 Feb 2007 19:19:12 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200702170325.02337.bzolnier@gmail.com> <45D9C0DD.6070500@ru.mvista.com> <45E31D0E.6070906@ru.mvista.com>
In-Reply-To: <45E31D0E.6070906@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261919.12944.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 26 February 2007, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >>> Contains: IRQ-ack fix for ICH chipsets (Albert Lee), ide-floppy 
> >>> unformatted
> >>> media fix (Alan Cox), more fixes for IDE PCI drivers (Sergei Shtylyov),
> >>> new driver for Toshiba Cell Reference Board (Kou Ishizaki <kou.ishizaki
> >>> at toshiba.co.jp>) and a bunch of rather obvious 
> >>> cleanups/improvements (me).
> 
> >>> There are still some bugfix patches in my tree which should go into 
> >>> 2.6.21
> >>> but since they are quite fresh and there have already been a lot of IDE
> >>> changes since the merge window was opened I will wait for -rc1 to push
> >>> them upstream.
> 
> >>> [ Andrew, IDE quilt tree has already been updated wrt to this update ]
> 
> >>    Which quilt tree do you mean? I've noticed that in 
> >> http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/ the series 
> >> file itself hasn't been updated, so this tree appears broken currently.
> 
> >    Begging your pardon, it's all browser caching. :-<
> 
>    Now it's *actually* borken since rtying to read 
> delkin_cb-pci_module_init-to-pci_register_driver.patch gets you "403 Forbidden"...

Doh, wrong permission (600 instead of 644) - I've fixed this once already but
only in the public tree and not in my private mirror so during last re-sync it
got broken again.   I corrected this in both trees this time :) but it will
take some time for the change to propagate to kernel.org mirrors.

[ Thankfully this patch is the last one in the series. ]

Thanks,
Bart

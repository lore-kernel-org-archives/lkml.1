Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXJPUvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXJPUvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936067AbXJPUtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:49:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:41817 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936049AbXJPUtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gE7CO3sduYiw+31rk+EkdPAIBr8fuUPPcL3/K8dbpxUgFi4voEdMNzHp1qfK4YPYf0b99MpvZ+XNghWUN8xK7amMgG8s5rTG5ouBKcjmvQwAaZUwg4EcQJCoc3okIbYnT/u1MEsk3tLdGuLVso1prvPo/JyWrC1YKJzqdDsVc2k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [git patches] IDE updates (part 2)
Date: Tue, 16 Oct 2007 21:41:01 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710131825.24768.bzolnier@gmail.com> <200710141807.24295.bzolnier@gmail.com> <1192396500.6188.4.camel@pasglop>
In-Reply-To: <1192396500.6188.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710162141.02019.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Benjamin Herrenschmidt wrote:
> 
> > How's about this patch?
> > 
> > [PATCH] ide-pmac: fix pmac_ide_init_hwif_ports()
> > 
> > * pmac_ide_init_hwif_ports() can be called by ide_init_hwif_ports()
> >   (through ppc_ide_md.ide_init_hwif hook) for non IDE PMAC interfaces.
> >   If this is the case the hw->io_ports[] should be already setup by
> >   ide_init_hwif_ports()->ide_std_init_ports() so remove redundant code
> >   from pmac_ide_init_hwif_ports().
> > 
> >   As side-effect this change fixes ctl_addr == 0 special handling in
> >   ide_init_hwif_ports().
> > 
> > * Fix misleading comment while at it.
> 
> I would have to try it. Problem is, I don't actually have any powermac
> with a PCI IDE controller at hand.. ouch. I'll see what I can find.

Same problem here, would be great if somebody with PMAC could test
this patch (should apply cleanly to Linus' tree).

Well, since the change is pretty safe I'm adding the patch to IDE tree
(so it hopefully gets tested through -mm).

Thanks,
Bart

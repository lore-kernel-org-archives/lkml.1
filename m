Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbXLaSgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbXLaSgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXLaSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:36:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXLaSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:36:13 -0500
Date: Mon, 31 Dec 2007 19:35:58 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Douglas Gilbert <dougg@torque.net>
cc: Matthew Wilcox <matthew@wil.cx>, Bodo Eggert <7eggert@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Bad escriptions in Kconfig
In-Reply-To: <47791A32.1020405@torque.net>
Message-ID: <alpine.LSU.0.999.0712311931080.5775@be1.lrz>
References: <alpine.LSU.0.999.0712311313050.3761@be1.lrz> <477907DB.8030406@torque.net>
 <20071231154731.GY11638@parisc-linux.org> <47791A32.1020405@torque.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+Xog8KbrQH/b+JkHPsGkeDv7PtOuDs04d0sOt
 qBIfzxkt2DxO6ivjAeV0BfeQpYrh1+5G22QMcRq0MGIUn7214h
 m+CgACGqbGmd9ZFaNY0Uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Dec 2007, Douglas Gilbert wrote:
> Matthew Wilcox wrote:
> > On Mon, Dec 31, 2007 at 10:16:43AM -0500, Douglas Gilbert wrote:
> >> Bodo Eggert wrote:

(Kicking netdev from CC)

> >>> ---
> >>> SCSI target support (SCSI_TGT) [N/m/y/?] (NEW) ?
> >>>
> >>> If you want to use SCSI target mode drivers enable this option.
> >>> If you choose M, the module will be called scsi_tgt.
> >>> ---
> >>>
> >>> What TF is a SCSI target mode, what is a target mode driver?
> >> Heard of google :-)
> >>
> >> For explanations of SCSI (and other storage) terminology
> >> reference could be made to SAM-3 or SAM-4 drafts (because
> >> the real standards cost money) at www.t10.org .
> >>
> >> Perhaps many other subsections in the kernel could have
> >> similar references.
> > 
> > I think that's an appalling idea.  Someone's trying to configure their
> > kernel, not research hundreds of new ideas on the internet.  Here's a
> > better description:
> > 
> > 	help
> > 	  The SCSI target code allows your computer to appear as a SCSI
> > 	  device.  This is useful in a SAN or NAS environment where you
> > 	  want other computers to be able to treat this computer as a disc.
> > 
> > 	  To compile this driver as a module, choose M here: the module
> > 	  will be called scsi_tgt.
> 
> Appalling or not, it is more accurate to define a SCSI target
> properly than equate it to a direct access logical unit (i.e.
> a disk).

Yes, but calling the current text a "help text" would be even less accurate.
Can you create a helpfull text without being incorrect?
-- 
Field experience is something you don't get until just after you need it.

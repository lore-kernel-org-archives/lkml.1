Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXLaPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXLaPrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 10:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXLaPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 10:47:34 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40491 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbXLaPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 10:47:32 -0500
Date: Mon, 31 Dec 2007 08:47:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Douglas Gilbert <dougg@torque.net>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bad escriptions in Kconfig
Message-ID: <20071231154731.GY11638@parisc-linux.org>
References: <alpine.LSU.0.999.0712311313050.3761@be1.lrz> <477907DB.8030406@torque.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477907DB.8030406@torque.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 10:16:43AM -0500, Douglas Gilbert wrote:
> Bodo Eggert wrote:
> > ---
> > SCSI target support (SCSI_TGT) [N/m/y/?] (NEW) ?
> > 
> > If you want to use SCSI target mode drivers enable this option.
> > If you choose M, the module will be called scsi_tgt.
> > ---
> > 
> > What TF is a SCSI target mode, what is a target mode driver?
> 
> Heard of google :-)
> 
> For explanations of SCSI (and other storage) terminology
> reference could be made to SAM-3 or SAM-4 drafts (because
> the real standards cost money) at www.t10.org .
> 
> Perhaps many other subsections in the kernel could have
> similar references.

I think that's an appalling idea.  Someone's trying to configure their
kernel, not research hundreds of new ideas on the internet.  Here's a
better description:

	help
	  The SCSI target code allows your computer to appear as a SCSI
	  device.  This is useful in a SAN or NAS environment where you
	  want other computers to be able to treat this computer as a disc.

	  To compile this driver as a module, choose M here: the module
	  will be called scsi_tgt.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

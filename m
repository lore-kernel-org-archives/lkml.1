Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYLTPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYLTPdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 10:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYLTPdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 10:33:01 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52669 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYLTPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 10:33:00 -0500
Date: Sat, 20 Dec 2008 08:32:58 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       willy@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] advansys: use request_firmware
Message-ID: <20081220153258.GU19967@parisc-linux.org>
References: <1229786727.15438.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229786727.15438.5.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 08:55:27PM +0530, Jaswinder Singh wrote:
> diff --git a/firmware/WHENCE b/firmware/WHENCE
> index 299301f..27105bc 100644
> --- a/firmware/WHENCE
> +++ b/firmware/WHENCE
> @@ -363,3 +363,16 @@ Licence: Allegedly GPLv2+, but no source visible. Marked:
>    Copyright (C) 2001 Qlogic Corporation (www.qlogic.com)
>  
>  --------------------------------------------------------------------------
> +
> +Driver: SCSI_ADVANSYS - AdvanSys SCSI
> +
> +File: advansys/mcode.bin
> +File: advansys/3550.bin
> +File: advansys/38C0800.bin
> +File: advansys/38C1600.bin
> +
> +Licence: Allegedly GPLv2+, but no source visible.
> +
> +Found in hex form in kernel source.

I thought we discussed this before.  If you take it from an earlier
version of the driver, you can get it under a disjunction of BSD and
GPL, and take the BSD option.

As far as I know, no source code has been published.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

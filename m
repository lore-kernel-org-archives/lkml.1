Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbXLaPRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbXLaPRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 10:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXLaPR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 10:17:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXLaPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 10:17:27 -0500
Message-ID: <477907DB.8030406@torque.net>
Date: Mon, 31 Dec 2007 10:16:43 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Bad escriptions in Kconfig
References: <alpine.LSU.0.999.0712311313050.3761@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0712311313050.3761@be1.lrz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> In some of the Kconfig files, the options are not adequately decribed. I 
> collected a few of the bad descriptions I found:
> 
> 
> ---
> Lowlevel video output switch controls (VIDEO_OUTPUT_CONTROL) [M/n/y/?] (NEW) ?
> 
> This framework adds support for low-level control of the video
> output switch.
> ---
> 
> - What is THE video output switch and why would I need low level control?
> 
> - Frameworks should be auto-selected like libraries, shouldn't they?
> 
> - WTF is this a module?
> 
> 
> -------------
> ---
> Auxiliary Display support (AUXDISPLAY) [N/y/?] (NEW) ?
> 
> Say Y here to get to see options for auxiliary display drivers.
> This option alone does not add any kernel code.
> ---
> 
> - If I knw what an axilary display was, I would not read this help text!
> 
> - After digging some time, I discovered that all Auxdisplays are parallel 
>   port devices.
>   Rename to "Parallel port display device support"?
> 
> 
> -------------
> ---
> Transformation user configuration interface (XFRM_USER) [N/m/y/?] (NEW)
>   
> Support for Transformation(XFRM) user configuration interface
> like IPsec used by native Linux tools.
> 
> If unsure, say Y.
> ---
> 
> - I'm not sure if these words combine to a sentence.
> - I can't tell if IPSEC is the only user or if I'd break other parts by not 
>   saying 'Y'. OTOH, I don't want to bloat my kernel ...
> - What's a native linux tool?
> 
>   
> -------------
> ---
> SCSI target support (SCSI_TGT) [N/m/y/?] (NEW) ?
> 
> If you want to use SCSI target mode drivers enable this option.
> If you choose M, the module will be called scsi_tgt.
> ---
> 
> What TF is a SCSI target mode, what is a target mode driver?

Heard of google :-)

For explanations of SCSI (and other storage) terminology
reference could be made to SAM-3 or SAM-4 drafts (because
the real standards cost money) at www.t10.org .

Perhaps many other subsections in the kernel could have
similar references.

Doug Gilbert



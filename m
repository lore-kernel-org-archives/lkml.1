Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZEDQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZEDQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZEDQRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:17:09 -0400
Received: from kroah.org ([198.145.64.141]:41713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZEDQRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:17:08 -0400
Date: Mon, 4 May 2009 09:12:32 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 4 (staging/comedi)
Message-ID: <20090504161232.GB11723@kroah.com>
References: <20090504170810.64cdceb4.sfr@canb.auug.org.au> <49FF0EEA.1010605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FF0EEA.1010605@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:51:06AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090501:
> 
> 
> build-r4048.out:ERROR: "ni_tio_rinsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "ni_tio_winsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "ni_tio_insn_config" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "ni_tio_init_counter" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "ni_gpct_device_construct" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "ni_gpct_device_destroy" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
> build-r4048.out:ERROR: "labpc_1200_is_unipolar" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> build-r4048.out:ERROR: "labpc_1200_ai_gain_bits" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> build-r4048.out:ERROR: "range_labpc_1200_ai" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> build-r4048.out:ERROR: "labpc_common_detach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> build-r4048.out:ERROR: "labpc_common_attach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
> build-r4048.out:ERROR: "das08_cs_boards" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
> build-r4048.out:ERROR: "das08_common_detach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
> build-r4048.out:ERROR: "das08_common_attach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
> 
> 
> config attached.

CONFIG_PCMCIA is allowed to be set without CONFIG_PCI?  That sounds like
the problem there (not to mention pretty much an impossible real-world
combination...)

thanks,

greg k-h

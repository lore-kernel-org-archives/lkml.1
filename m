Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZDFC0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZDFC0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 22:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZDFC0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 22:26:21 -0400
Received: from kroah.org ([198.145.64.141]:46437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318AbZDFC0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 22:26:21 -0400
Date: Sun, 5 Apr 2009 19:23:57 -0700
From: Greg KH <greg@kroah.com>
To: Jon Grant <jg@jguk.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB disconnect, address 6
Message-ID: <20090406022356.GA866@kroah.com>
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 07:04:45PM +0100, Jon Grant wrote:
> Hello
> 
> Would there be a way to propagate the device name back from the scsi
> system to the usb so it can name the device which is disconnected in
> the output? This saves needing to go hunting to find what the
> disconnected device was.

What do you mean, all the info needed is already in the messages below,
what more do you need?

> Apr  5 18:56:33 data-laptop kernel: [65426.948048] usb 5-1: new high speed USB device using ehci_hcd and address 6
> Apr  5 18:56:33 data-laptop kernel: [65427.132049] usb 5-1: configuration #1 chosen from 1 choice
> Apr  5 18:56:33 data-laptop kernel: [65427.152066] scsi4 : SCSI emulation for USB Mass Storage devices
> Apr  5 18:56:38 data-laptop kernel: [65432.153182] scsi 4:0:0:0: Direct-Access     Samsung  Mighty Drive     PMAP PQ: 0 ANSI: 0 CCS
> Apr  5 18:56:38 data-laptop kernel: [65432.454122] sd 4:0:0:0: [sdc] 2014208 512-byte hardware sectors (1031 MB)
> Apr  5 18:56:38 data-laptop kernel: [65432.454867] sd 4:0:0:0: [sdc] Write Protect is off
> Apr  5 18:56:38 data-laptop kernel: [65432.458744] sd 4:0:0:0: [sdc] 2014208 512-byte hardware sectors (1031 MB)
> Apr  5 18:56:38 data-laptop kernel: [65432.459866] sd 4:0:0:0: [sdc] Write Protect is off
> Apr  5 18:56:38 data-laptop kernel: [65432.461202]  sdc: sdc1
> Apr  5 18:56:38 data-laptop kernel: [65432.462224] sd 4:0:0:0: [sdc] Attached SCSI removable disk
> Apr  5 18:56:38 data-laptop kernel: [65432.462547] sd 4:0:0:0: Attached scsi generic sg2 type 0
> Apr  5 18:56:58 data-laptop kernel: [65451.669308] usb 5-1: USB disconnect, address 6


confused,

greg k-h

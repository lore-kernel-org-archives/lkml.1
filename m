Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYJ3QUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYJ3QUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYJ3QUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:20:21 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:64656 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYJ3QUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:20:20 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: "Yang, Libin" <Libin.Yang@amd.com>
Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Thu, 30 Oct 2008 17:19:10 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.4r4; KDE/4.1.71; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Huang, Shane" <Shane.Huang@amd.com>
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com> <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810301719.10712.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 30 Oktober 2008, Yang, Libin wrote:
> Thanks for reporting this bug. We are trying to reproduce this bug and
> will look into it.

for comparism, a disk drive in a different enclosure:

[  761.088203] usb 1-1: new high speed USB device using ehci_hcd and address 4              
[  761.220420] usb 1-1: configuration #1 chosen from 1 choice                               
[  761.220829] usb 1-1: New USB device found, idVendor=05e3, idProduct=0702                 
[  761.220834] usb 1-1: New USB device strings: Mfr=2, Product=3, 
SerialNumber=0            
[  761.220836] usb 1-1: Product: USB Mass Storage Device                                    
[  761.220837] usb 1-1: Manufacturer: Genesyslogic                                          
[  761.255803] Initializing USB Mass Storage driver...                                      
[  761.256355] scsi6 : SCSI emulation for USB Mass Storage devices                          
[  761.256442] usb-storage: device found at 4                                               
[  761.256447] usb-storage: waiting for device to settle before scanning                    
[  761.256453] usbcore: registered new interface driver usb-storage                         
[  761.256456] USB Mass Storage support registered.                                         
[  766.253542] usb-storage: device scan complete                                            
[  766.257891] scsi 6:0:0:0: Direct-Access     WDC WD12 00JB-00CRA1      0811 
PQ: 0 ANSI: 0 
[  766.260502] sd 6:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 
MB)            
[  766.261877] sd 6:0:0:0: [sdc] Test WP failed, assume Write Enabled                       
[  766.261879] sd 6:0:0:0: [sdc] Assuming drive cache: write through                        
[  766.264632] sd 6:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 
MB)            
[  766.268226] sd 6:0:0:0: [sdc] Test WP failed, assume Write Enabled                       
[  766.268232] sd 6:0:0:0: [sdc] Assuming drive cache: write through                        
[  766.268236]  sdc: sdc1 sdc2                                                              
[  766.272977] sd 6:0:0:0: [sdc] Attached SCSI disk                                         
[  766.273029] sd 6:0:0:0: Attached scsi generic sg2 type 0                                 
[  790.301384] ReiserFS: sdc2: found reiserfs format "3.6" with standard 
journal            
[  790.301501] ReiserFS: sdc2: using ordered data mode                                      
[  790.313008] ReiserFS: sdc2: journal params: device sdc2, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30                   
[  790.313761] ReiserFS: sdc2: checking transaction log (sdc2)                              
[  790.349505] ReiserFS: sdc2: Using r5 hash to sort names  

I started to copy a file from sdc2, after 1,8MB usb locked up, without any 
messages.

Glück Auf,
Volker

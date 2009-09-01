Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZIAUee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZIAUee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZIAUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:34:34 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30464 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZIAUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:34:33 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=Mv5P-v-zDEQA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=G_Br9k3cenmALjQnW4AA:9 a=TTQZ-A-N_g4EjrdGlLQA:7
 a=yGiaztQqX3Y39me5IOTv_HulD-cA:4 a=U62fhAwekXMA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: sata exception frozen timeout?
Date: Tue, 1 Sep 2009 14:34:34 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.30-1-amd64; KDE/4.3.64; x86_64; svn-1004284; 2009-07-29)
References: <200909010316.58715.tfjellstrom@shaw.ca> <200909010428.18403.tfjellstrom@shaw.ca>
In-Reply-To: <200909010428.18403.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Message-Id: <200909011434.34381.tfjellstrom@shaw.ca>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue September 1 2009, Thomas Fjellstrom wrote:
> On Tue September 1 2009, Thomas Fjellstrom wrote:
> > I've recently started seeing the following messages from a new WD Green
> > drive, not long after I had to RMA a Seagate drive for a strange (but
> > different) error. Highlights from my dmesg include:
> >
> > [59634.792101] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [59634.792121] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [59634.792125]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [59634.792133] ata6.00: status: { DRDY }
> > [59634.792145] ata6: hard resetting link
> > [59635.277695] ata6: softreset failed (device not ready)
> > [59635.277705] ata6: failed due to HW bug, retry pmp=0
> > [59635.441570] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [59635.454030] ata6.00: configured for UDMA/133
> > [59635.454068] ata6: EH complete
> > ...
> > [59713.792224] ata6.00: NCQ disabled due to excessive errors
> > [59713.792236] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [59713.792254] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [59713.792257]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [59713.792264] ata6.00: status: { DRDY }
> > ...
> > [63484.781764] ata6: hard resetting link
> > [63485.264204] ata6: softreset failed (device not ready)
> > [63485.264214] ata6: failed due to HW bug, retry pmp=0
> > [63485.428205] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > [63485.440499] ata6.00: configured for UDMA/100
> > [63485.440536] ata6: EH complete
> > [63493.780182] ata6.00: limiting speed to UDMA/33:PIO4
> > [63493.780194] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> > frozen
> > [63493.780211] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> > [63493.780214]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
> > (timeout)
> > [63493.780221] ata6.00: status: { DRDY }
> > ...
> > [99318.070669] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> > [99318.070679] ata6.00: irq_stat 0x40000001
> > [99318.070698] ata6.00: cmd 25/00:00:30:bd:01/00:01:1b:00:00/e0 tag 0 dma
> > 131072 in
> > [99318.070701]          res 41/04:ef:30:bd:01/00:00:1b:00:00/e0 Emask 0x1
> > (device error)
> > [99318.070709] ata6.00: status: { DRDY ERR }
> > [99318.070714] ata6.00: error: { ABRT }
> > [99318.082588] ata6.00: configured for UDMA/33
> > [99318.082612] ata6: EH complete
> > ...
> > [99339.780358] ata6: hard resetting link
> > [99349.785096] ata6: softreset failed (device not ready)
> > [99349.785108] ata6: hard resetting link
> > [99359.789033] ata6: softreset failed (device not ready)
> > [99359.789045] ata6: hard resetting link
> > [99370.352916] ata6: link is slow to respond, please be patient (ready=0)
> > ..
> > [99400.016925] ata6: softreset failed (device not ready)
> > [99400.016936] ata6: reset failed, giving up
> > [99400.016942] ata6.00: disabled
> > [99400.016986] ata6: EH complete
> > [99400.017021] sd 5:0:0:0: [sdf] Unhandled error code
> > [99400.017026] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> > driverbyte=DRIVER_OK
> > [99400.017021] sd 5:0:0:0: [sdf] Unhandled error code
> > [99400.017026] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> > driverbyte=DRIVER_OK
> > [99400.017035] end_request: I/O error, dev sdf, sector 453099568
> > [99400.017045] Buffer I/O error on device md1, logical block 113274390
> > [99400.017058] Buffer I/O error on device md1, logical block 113274391
> > [99400.017064] Buffer I/O error on device md1, logical block 113274392
> > [99400.017070] Buffer I/O error on device md1, logical block 113274393
> > [99400.017076] Buffer I/O error on device md1, logical block 113274394
> > [99400.017082] Buffer I/O error on device md1, logical block 113274395
> > [99400.017088] Buffer I/O error on device md1, logical block 113274396
> > [99400.017094] Buffer I/O error on device md1, logical block 113274397
> > [99400.017100] Buffer I/O error on device md1, logical block 113274398
> > [99400.017106] Buffer I/O error on device md1, logical block 113274399
> > [99400.017115] sd 5:0:0:0: [sdf] Unhandled error code
> > [99400.017123] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> > driverbyte=DRIVER_OK
> > [99400.017133] end_request: I/O error, dev sdf, sector 453099824
> > [99400.017310] sd 5:0:0:0: [sdf] Unhandled error code
> > [99400.017315] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> > driverbyte=DRIVER_OK
> > [99400.017322] end_request: I/O error, dev sdf, sector 453099568
> > [99400.017383] program smartctl is using a deprecated SCSI ioctl, please
> > convert it to SG_IO
> > [99400.017456] program smartctl is using a deprecated SCSI ioctl, please
> > convert it to SG_IO
> > [99400.018822] sd 5:0:0:0: [sdf] Unhandled error code
> > [99400.018829] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET
> > driverbyte=DRIVER_OK
> > [99400.018838] end_request: I/O error, dev sdf, sector 453099568
> >
> > and a bunch more end_request errors. This happens fairly reliably after a
> > day or so of being online. I try and start to play some music or watch a
> > video off the array (2xWD Green on md raid0) and it fails. The file
> > system is mostly read only right now (that is I don't write to it) so I
> > haven't manged to loose any data that I know of, and the fs seems to be
> > fine. A reboot fixes the errors and the disk and fs work fine for a day
> > or two before these errors show up again.
> >
> > I'm currently running 2.6.31-rc5 from kernel.org. What would cause these
> > errors?
>
> It's now happened again after only 30 minutes or so. I'm trying with an
> older kernel (debian's 2.6.30-6 from sid) now. So far so good.

Lasted a whole half a day this time:

[29461.780188] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen                                                                           
[29461.780208] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0                                                                                     
[29461.780211]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 
(timeout)                                                                       
[29461.780219] ata8.00: status: { DRDY }                                                                                                                  
[29461.780230] ata8: hard resetting link                                                                                                                  
[29462.264190] ata8: softreset failed (device not ready)                                                                                                  
[29462.264198] ata8: failed due to HW bug, retry pmp=0                                                                                                    
[29462.428205] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                     
[29462.440501] ata8.00: configured for UDMA/133                                                                                                           
[29462.440541] ata8: EH complete                                                                                                                          
[29469.780184] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen                                                                           
[29469.780204] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0                                                                                     
[29469.780207]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)                                                                       
[29469.780215] ata8.00: status: { DRDY }                                                                                                                  
[29469.780227] ata8: hard resetting link                                                                                                                  
[29470.264245] ata8: softreset failed (device not ready)                                                                                                  
[29470.264254] ata8: failed due to HW bug, retry pmp=0                                                                                                    
[29470.428710] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                     
[29470.442007] ata8.00: configured for UDMA/133                                                                                                           
[29470.442040] ata8: EH complete                                                                                                                          
[30861.793185] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen                                                                           
[30861.793205] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0                                                                                     
[30861.793208]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 
(timeout)                                                                       
[30861.793216] ata8.00: status: { DRDY }                                                                                                                  
[30861.793228] ata8: hard resetting link                                                                                                                  
[30862.389604] ata8: softreset failed (device not ready)                                                                                                  
[30862.389614] ata8: failed due to HW bug, retry pmp=0                                                                                                    
[30862.553541] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                     
[30862.565716] ata8.00: configured for UDMA/133                                                                                                           
[30862.565758] ata8: EH complete                                                                                                                          
[30869.793199] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen                                                                           
[30869.793219] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0                                                                                     
[30869.793223]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)                                                                       
[30869.793230] ata8.00: status: { DRDY }                                                                                                                  
[30869.793242] ata8: hard resetting link                                                                                                                  
[30870.333570] ata8: softreset failed (device not ready)                                                                                                  
[30870.333579] ata8: failed due to HW bug, retry pmp=0                                                                                                    
[30870.497680] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                                                     
[30870.509783] ata8.00: configured for UDMA/133                                                                                                           
[30870.509813] ata8: EH complete                                                                                                                          
[36301.639209] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0                                                                                  
[36301.639218] ata8.00: irq_stat 0x40000008                                                                                                               
[36301.639237] ata8.00: cmd 60/18:00:80:e9:09/00:00:23:00:00/40 tag 0 ncq 
12288 in                                                                        
[36301.639240]          res 41/04:07:80:e9:09/00:00:23:00:00/40 Emask 0x401 
(device error) <F>                                                            
[36301.639248] ata8.00: status: { DRDY ERR }                                                                                                              
[36301.639253] ata8.00: error: { ABRT }                                                                                                                   
[36301.652443] ata8.00: configured for UDMA/133                                                                                                           
[36301.652466] ata8: EH complete                                                                                                                          
[36329.593455] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0                                                                                  
[36329.593472] ata8.00: irq_stat 0x40000008                                                                                                               
[36329.593491] ata8.00: cmd 60/18:00:80:e9:09/00:00:23:00:00/40 tag 0 ncq 
12288 in                                                                        
[36329.593495]          res 41/04:07:80:e9:09/00:00:23:00:00/40 Emask 0x401 
(device error) <F>                                                            
[36329.593524] ata8.00: status: { DRDY ERR }                                                                                                              
[36329.593530] ata8.00: error: { ABRT }                                                                                                                   
[36329.605664] ata8.00: configured for UDMA/133                                                                                                           
[36329.605687] ata8: EH complete                                                                                                                          
[36352.125981] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0                                                                                  
[36352.125991] ata8.00: irq_stat 0x40000008                                                                                                               
[36352.126009] ata8.00: cmd 60/18:00:80:e9:09/00:00:23:00:00/40 tag 0 ncq 
12288 in                                                                        
[36352.126013]          res 41/04:07:80:e9:09/00:00:23:00:00/40 Emask 0x401 
(device error) <F>                                                            
[36352.126021] ata8.00: status: { DRDY ERR }                                                                                                              
[36352.126026] ata8.00: error: { ABRT }                                                                                                                   
[36352.138677] ata8.00: configured for UDMA/133                                                                                                           
[36352.138700] ata8: EH complete                                                                                                                          
[36370.337334] ata8.00: NCQ disabled due to excessive errors                                                                                              
[36370.337339] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0                                                                                  
[36370.337341] ata8.00: irq_stat 0x40000008                                                                                                               
[36370.337347] ata8.00: cmd 60/18:00:80:e9:09/00:00:23:00:00/40 tag 0 ncq 
12288 in                                                                        
[36370.337348]          res 41/04:07:80:e9:09/00:00:23:00:00/40 Emask 0x401 
(device error) <F>                                                            
[36370.337350] ata8.00: status: { DRDY ERR }                                                                                                              
[36370.337352] ata8.00: error: { ABRT }                                                                                                                   
[36370.349333] ata8.00: configured for UDMA/133                                                                                                           
[36370.349360] ata8: EH complete                                                                                                                          
[36379.641876] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0                                                                                  
[36379.641885] ata8.00: irq_stat 0x40000001                                                                                                               
[36379.641903] ata8.00: cmd 25/00:18:80:e9:09/00:00:23:00:00/e0 tag 0 dma 
12288 in                                                                        
[36379.641907]          res 41/04:07:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)                                                                  
[36379.641915] ata8.00: status: { DRDY ERR }                                                                                                              
[36379.641920] ata8.00: error: { ABRT }                                                                                                                   
[36379.653754] ata8.00: configured for UDMA/133                                                                                                           
[36379.653779] ata8: EH complete
[36388.973359] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[36388.973368] ata8.00: irq_stat 0x40000001
[36388.973386] ata8.00: cmd 25/00:18:80:e9:09/00:00:23:00:00/e0 tag 0 dma 
12288 in
[36388.973390]          res 41/04:07:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)
[36388.973398] ata8.00: status: { DRDY ERR }
[36388.973403] ata8.00: error: { ABRT }
[36388.985379] ata8.00: configured for UDMA/133
[36388.985404] sd 7:0:0:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[36388.985412] sd 7:0:0:0: [sdf] Sense Key : Aborted Command [current] 
[descriptor]
[36388.985422] Descriptor sense data with sense descriptors (in hex):
[36388.985426]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[36388.985445]         23 09 e9 80
[36388.985453] sd 7:0:0:0: [sdf] Add. Sense: No additional sense information
[36388.985462] end_request: I/O error, dev sdf, sector 587852160
[36388.985470] Buffer I/O error on device md1, logical block 146962544
[36388.985482] Buffer I/O error on device md1, logical block 146962545
[36388.985488] Buffer I/O error on device md1, logical block 146962546
[36388.985524] ata8: EH complete
[36398.303765] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[36398.303774] ata8.00: irq_stat 0x40000001
[36398.303792] ata8.00: cmd 25/00:08:80:e9:09/00:00:23:00:00/e0 tag 0 dma 4096 
in
[36398.303796]          res 41/04:00:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)
[36398.303803] ata8.00: status: { DRDY ERR }
[36398.303808] ata8.00: error: { ABRT }
[36398.315894] ata8.00: configured for UDMA/133
[36398.315916] ata8: EH complete
[36407.346978] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[36407.346982] ata8.00: irq_stat 0x40000001
[36407.346988] ata8.00: cmd 25/00:08:80:e9:09/00:00:23:00:00/e0 tag 0 dma 4096 
in
[36407.346989]          res 41/04:00:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)
[36407.346991] ata8.00: status: { DRDY ERR }
[36407.346993] ata8.00: error: { ABRT }
[36407.358876] ata8.00: configured for UDMA/133
[36407.358888] ata8: EH complete
[36416.680069] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[36416.680079] ata8.00: irq_stat 0x40000001
[36416.680097] ata8.00: cmd 25/00:08:80:e9:09/00:00:23:00:00/e0 tag 0 dma 4096 
in
[36416.680101]          res 41/04:00:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)
[36416.680109] ata8.00: status: { DRDY ERR }
[36416.680114] ata8.00: error: { ABRT }
[36416.692769] ata8.00: configured for UDMA/133
[36416.692792] ata8: EH complete
[36426.011216] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[36426.011225] ata8.00: irq_stat 0x40000001
[36426.011243] ata8.00: cmd 25/00:08:80:e9:09/00:00:23:00:00/e0 tag 0 dma 4096 
in
[36426.011246]          res 41/04:00:80:e9:09/00:00:23:00:00/e0 Emask 0x1 
(device error)
[36426.011254] ata8.00: status: { DRDY ERR }
[36426.011259] ata8.00: error: { ABRT }
[36426.023178] ata8.00: configured for UDMA/133
[36426.023202] ata8: EH complete

Is this a hardware error?

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

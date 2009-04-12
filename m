Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZDLIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZDLIvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZDLIux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 04:50:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:40030 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZDLIus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 04:50:48 -0400
Subject: Re: 2.6.29.1: card reader goes crazy
From: Thomas Meyer <thomas@m3y3r.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200904112209.00735.rjw@sisk.pl>
References: <1239353267.3467.4.camel@localhost.localdomain>
	 <200904112209.00735.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Apr 2009 10:50:26 +0200
Message-Id: <1239526226.3995.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 11.04.2009, 22:09 +0200 schrieb Rafael J. Wysocki:
> On Friday 10 April 2009, Thomas Meyer wrote:
> > Hi,
> > 
> > 1.) Probably suspend/resume to/from ram related?
> 
> Is this a regression?  Ie. is 2.6.28(.x) fine?

Just tested 2.6.28.9. Same behaviour. Is it possible that some userland
software is responsible for this? hal? And why doesn't it stop after
resume from ram? And why does it stop after replug the hub again?

So this is not a regression. Does this matter?

[   12.776434] type=1403 audit(1239490798.171:3): policy loaded auid=4294967295 ses=4294967295
[   18.895252] udevd version 127 started
[   21.416339] cfg80211: Calling CRDA to update world regulatory domain
[   22.037233] cfg80211: World regulatory domain updated:
[   22.037240] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   22.037246] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.037251] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   22.037256] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   22.037260] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.037265] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.434217] ath5k_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   22.434234] ath5k_pci 0000:03:00.0: setting latency timer to 64
[   22.434509] ath5k_pci 0000:03:00.0: registered as 'phy0'
[   22.521430] phy0: Selected rate control algorithm 'minstrel'
[   22.521704] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
[   22.871466] cfg80211: Calling CRDA for country: DE
[   22.874121] cfg80211: Regulatory domain changed to country: DE
[   22.874126] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   22.874132] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   22.874137] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   22.874141] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[   24.728196] EXT4 FS on dm-0, internal journal on dm-0:8
[   25.102989] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   25.103010] SELinux: initialized (dev sda3, type ext2), uses xattr
[   25.103921] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   30.192071] JBD: barrier-based sync failed on dm-0:8 - disabling barriers
[   31.936065] Adding 2039728k swap on /dev/mapper/luks-swap.  Priority:-1 extents:1 across:2039728k
[   31.939875] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   32.505426] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   32.549491] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   32.549679] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   32.549684] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   32.549688] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   32.649794] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.952996] cfg80211: Calling CRDA for country: DE
[   36.557788] [drm] Setting GART location based on new memory map
[   36.558674] [drm] Loading R500 Microcode
[   36.558741] [drm] Num pipes: 1
[   36.558752] [drm] writeback test succeeded in 1 usecs
[   39.608949] sky2 eth0: enabling interface
[   39.609278] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.643991] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   54.020155] usb 1-1: new high speed USB device using ehci_hcd and address 6
[   54.145277] usb 1-1: configuration #1 chosen from 1 choice
[   54.145673] hub 1-1:1.0: USB hub found
[   54.145971] hub 1-1:1.0: 4 ports detected
[   54.148100] usb 1-1: New USB device found, idVendor=05e3, idProduct=0608
[   54.148106] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   54.148111] usb 1-1: Product: USB2.0 Hub
[   54.413783] usb 1-1.1: new high speed USB device using ehci_hcd and address 7
[   54.499674] usb 1-1.1: configuration #1 chosen from 1 choice
[   54.501982] scsi4 : SCSI emulation for USB Mass Storage devices
[   54.502113] usb-storage: device found at 7
[   54.502117] usb-storage: waiting for device to settle before scanning
[   54.502599] usb 1-1.1: New USB device found, idVendor=0dda, idProduct=2005
[   54.502605] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   54.502610] usb 1-1.1: Product: USB2.0 Card Reader
[   54.502613] usb 1-1.1: Manufacturer: ICSI
[   54.502617] usb 1-1.1: SerialNumber: 0000001
[   54.607015] usb 1-1.3: new low speed USB device using ehci_hcd and address 8
[   54.699429] usb 1-1.3: configuration #1 chosen from 1 choice
[   54.704965] input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.3/1-1.3:1.0/input/input12
[   54.750844] generic-usb 0003:413C:2003.0006: input,hidraw5: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:1d.7-1.3/input0
[   54.760632] input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.3/1-1.3:1.1/input/input13
[   54.787923] generic-usb 0003:413C:2003.0007: input,hidraw6: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:1d.7-1.3/input1
[   54.788094] usb 1-1.3: New USB device found, idVendor=413c, idProduct=2003
[   54.788099] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   54.788104] usb 1-1.3: Product: DELL USB Keyboard
[   54.788108] usb 1-1.3: Manufacturer: DELL
[   54.860516] usb 1-1.4: new low speed USB device using ehci_hcd and address 9
[   54.973270] usb 1-1.4: configuration #1 chosen from 1 choice
[   54.981002] input: Microsoft Microsoft IntelliMouse® Optical as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1.4/1-1.4:1.0/input/input14
[   55.007186] generic-usb 0003:045E:0029.0008: input,hidraw7: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:1d.7-1.4/input0
[   55.007353] usb 1-1.4: New USB device found, idVendor=045e, idProduct=0029
[   55.007359] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   55.007364] usb 1-1.4: Product: Microsoft IntelliMouse® Optical
[   55.007368] usb 1-1.4: Manufacturer: Microsoft
[   59.504516] usb-storage: device scan complete
[   59.505707] scsi 4:0:0:0: Direct-Access     ICSI     IC1210        CF 1.5B PQ: 0 ANSI: 0 CCS
[   59.507598] scsi 4:0:0:1: Direct-Access     ICSI     IC1210        MS 1.5B PQ: 0 ANSI: 0 CCS
[   59.510732] scsi 4:0:0:2: Direct-Access     ICSI     IC1210    MMC/SD 1.5B PQ: 0 ANSI: 0 CCS
[   59.511991] scsi 4:0:0:3: Direct-Access     ICSI     IC1210        SM 1.5B PQ: 0 ANSI: 0 CCS
[   59.519144] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   59.519268] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   59.520504] sd 4:0:0:1: [sdc] Attached SCSI removable disk
[   59.520626] sd 4:0:0:1: Attached scsi generic sg3 type 0
[   59.529199] sd 4:0:0:2: [sdd] Attached SCSI removable disk
[   59.529327] sd 4:0:0:2: Attached scsi generic sg4 type 0
[   59.530522] sd 4:0:0:3: [sde] Attached SCSI removable disk
[   59.530610] sd 4:0:0:3: Attached scsi generic sg5 type 0
[   59.878387] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   65.882634] wlan0: authenticate with AP 00:23:08:1d:f2:bb
[   65.924227] wlan0: authenticated
[   65.924235] wlan0: associate with AP 00:23:08:1d:f2:bb
[   65.943972] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=2)
[   65.943978] wlan0: associated
[   65.945148] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   72.109427] hfs: write access to a journaled filesystem is not supported, use the force option at your own risk, mounting read-only.
[   72.309949] SELinux: initialized (dev sda2, type hfsplus), uses genfs_contexts
[   76.274216] wlan0: no IPv6 routers present
[  105.321900] sky2 eth0: disabling interface
[  105.458456] [drm] Num pipes: 1
[  105.550074] wlan0: disassociating by local choice (reason=3)
[  105.575548] wlan0: authenticate with AP 00:23:08:1d:f2:bb
[  105.590352] wlan0: authenticated
[  105.590360] wlan0: associate with AP 00:23:08:1d:f2:bb
[  105.607890] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=2)
[  105.607897] wlan0: associated
[  115.404482] usb 1-1.1: reset high speed USB device using ehci_hcd and address 7
[  115.522244] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.522311] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.522547] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.531732] sd 4:0:0:2: [sdd] Unit Not Ready
[  115.531795] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.532013] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.534391] sd 4:0:0:0: [sdb] Unit Not Ready
[  115.534454] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.534672] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.535995] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.536058] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.536191] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.536427] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.537033] sd 4:0:0:3: [sde] Unit Not Ready
[  115.537095] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.537313] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.547007] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  115.547084] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  115.562984] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  115.563049] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  115.563166] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.563403] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.564619] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.564726] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.564976] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.569362] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  115.569457] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  115.570733] sd 4:0:0:3: [sde] READ CAPACITY failed
[  115.570839] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  115.570992] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.571244] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.572608] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  115.572700] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  115.572846] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.573092] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.575483] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  115.575577] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  115.584361] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  115.584457] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  115.593360] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.593463] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.593611] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.593871] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.595605] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  115.595706] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  115.639988] sd 4:0:0:2: [sdd] Unit Not Ready
[  115.640108] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.640366] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.642387] sd 4:0:0:3: [sde] Unit Not Ready
[  115.642496] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.642748] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.648860] sd 4:0:0:0: [sdb] Unit Not Ready
[  115.648952] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.649199] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.664754] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  115.664867] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  115.665013] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.665292] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.665622] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.665726] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.665997] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.667095] sd 4:0:0:3: [sde] READ CAPACITY failed
[  115.667187] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  115.667333] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.667603] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.669113] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  115.669205] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  115.669351] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.669599] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.674626] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  115.674740] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  115.677104] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  115.677206] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  115.683889] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  115.683994] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  115.694981] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.695080] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.695227] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.695474] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.712477] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  115.712579] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  115.713594] sd 4:0:0:3: [sde] Unit Not Ready
[  115.713686] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.713935] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.722600] sd 4:0:0:2: [sdd] Unit Not Ready
[  115.722693] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.722939] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.724847] sd 4:0:0:0: [sdb] Unit Not Ready
[  115.724940] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.725191] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.733225] sd 4:0:0:3: [sde] READ CAPACITY failed
[  115.733320] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  115.733486] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.733733] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.736349] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  115.736445] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  115.737347] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.737438] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.737703] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.751982] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  115.752079] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  115.752226] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.752472] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.754977] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  115.755071] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  115.755218] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.755466] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.756598] sd 4:0:0:3: [sde] Unit Not Ready
[  115.756696] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.756943] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.758477] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.758570] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.758719] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.758968] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.764989] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  115.765108] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  115.767477] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  115.767592] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  115.769102] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  115.769199] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  115.786998] sd 4:0:0:3: [sde] READ CAPACITY failed
[  115.787101] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  115.787251] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.787517] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.788979] sd 4:0:0:0: [sdb] Unit Not Ready
[  115.789075] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.789325] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.791745] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  115.791843] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  115.793001] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.793111] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.793385] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.799493] sd 4:0:0:2: [sdd] Unit Not Ready
[  115.799585] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.799831] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.815128] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.815234] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.815382] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.815665] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.821869] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  115.821961] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  115.822108] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.822355] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  115.823622] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  115.823727] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  115.824993] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  115.825088] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  115.825236] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  115.825485] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  115.832373] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  115.832470] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  115.834493] sd 4:0:0:3: [sde] Unit Not Ready
[  115.834584] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  115.834831] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  115.842377] sd 4:0:0:1: [sdc] Unit Not Ready
[  115.842486] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.842757] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.843553] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  115.843649] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  115.870155] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  115.870271] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  115.870432] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  115.870700] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  115.870952] sd 4:0:0:2: [sdd] Unit Not Ready
[  115.871043] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  115.871288] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.404497] usb 1-1.1: reset high speed USB device using ehci_hcd and address 7
[  123.498010] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  123.498131] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  123.504121] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.504247] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.504393] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.504642] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.512617] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.512711] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.512957] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.514401] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.514497] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.519506] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.519617] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.519763] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.520064] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.525130] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.525244] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  123.526001] sd 4:0:0:1: [sdc] Unit Not Ready
[  123.526103] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  123.526373] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  123.546232] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.546329] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.546476] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.546729] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.549606] sd 4:0:0:3: [sde] Unit Not Ready
[  123.549701] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.549950] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.556619] sd 4:0:0:2: [sdd] Unit Not Ready
[  123.556746] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.557020] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.557761] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  123.557870] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  123.558016] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  123.558300] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  123.560490] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.560589] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.567629] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  123.567742] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  123.574367] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.574460] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.574606] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.574852] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.580756] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.580875] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.581022] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.581302] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.583487] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.583592] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.591143] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.591261] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  123.592005] sd 4:0:0:1: [sdc] Unit Not Ready
[  123.592112] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  123.592380] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  123.592871] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.592964] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.593215] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.613623] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  123.613725] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  123.613873] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  123.614165] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  123.616740] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.616836] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.616989] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.617238] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.624863] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  123.624970] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  123.625857] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.625959] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.629615] sd 4:0:0:3: [sde] Unit Not Ready
[  123.629712] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.629964] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.639132] sd 4:0:0:2: [sdd] Unit Not Ready
[  123.639229] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.639477] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.648620] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.648712] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.648858] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.649104] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.650244] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.650334] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.650581] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.657746] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.657841] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.663995] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.664087] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.664259] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.664506] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.666747] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.666840] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.666986] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.667234] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.672249] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.672344] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  123.673497] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.673591] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.682868] sd 4:0:0:3: [sde] Unit Not Ready
[  123.682959] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.683207] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.692869] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.692962] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.693211] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.702120] sd 4:0:0:2: [sdd] Unit Not Ready
[  123.702211] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.702458] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.703746] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.703837] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.703983] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.704257] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.706742] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.706837] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.713860] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.713956] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.714105] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.714371] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.720625] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.720722] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.726623] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.726739] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.726884] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.727132] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.732999] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.733094] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  123.735871] sd 4:0:0:3: [sde] Unit Not Ready
[  123.735962] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.736209] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.752365] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.752463] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.752721] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.761623] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.761717] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.761864] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.762110] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.769873] sd 4:0:0:2: [sdd] Unit Not Ready
[  123.769964] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.770230] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.777624] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.777720] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.778873] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.778965] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.779110] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.779356] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.786234] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.786341] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.791237] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.791343] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.791494] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.791744] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.800139] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.800240] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  123.801251] sd 4:0:0:3: [sde] Unit Not Ready
[  123.801343] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.801591] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.817749] sd 4:0:0:0: [sdb] Unit Not Ready
[  123.817839] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.818088] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.824744] sd 4:0:0:2: [sdd] Unit Not Ready
[  123.824847] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.825098] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.829002] sd 4:0:0:3: [sde] READ CAPACITY failed
[  123.829096] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  123.829241] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  123.829490] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  123.836626] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  123.836744] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  123.842876] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  123.842968] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  123.843115] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  123.843386] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  123.848377] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  123.848470] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  123.848616] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  123.848863] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  123.850127] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  123.850222] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  123.855129] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  123.855225] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  124.696424] PM: Syncing filesystems ... done.
[  124.703244] PM: Preparing system for mem sleep
[  124.703256] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  124.711006] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  124.723826] PM: Entering mem sleep
[  124.723843] Suspending console(s) (use no_console_suspend to debug)
[  124.836896] sd 2:0:1:0: [sda] Synchronizing SCSI cache
[  124.912915] sd 2:0:1:0: [sda] Stopping disk
[  125.352377] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[  125.352382] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[  125.352387] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  125.352416] ACPI handle has no context!
[  125.363723] ath5k_pci 0000:03:00.0: PCI INT A disabled
[  125.390352] ata_piix 0000:00:1f.2: PCI INT B disabled
[  125.403542] ata_piix 0000:00:1f.1: PCI INT A disabled
[  125.403763] ata_piix 0000:00:1f.1: power state changed by ACPI to D3
[  125.403920] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  125.416762] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  125.416803] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  125.416844] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  125.416885] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  125.416890] pciehp 0000:00:1c.2:pcie02: pciehp_suspend ENTRY
[  125.416950] pciehp 0000:00:1c.1:pcie02: pciehp_suspend ENTRY
[  125.417010] pciehp 0000:00:1c.0:pcie02: pciehp_suspend ENTRY
[  125.430336] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  125.443573] PM: suspend devices took 0.720 seconds
[  125.445701] ACPI: Preparing to enter system sleep state S3
[  125.446810] Disabling non-boot CPUs ...
[  125.447946] Breaking affinity for irq 9
[  125.447975] Breaking affinity for irq 19
[  125.447980] Breaking affinity for irq 22
[  125.447985] Breaking affinity for irq 23
[  125.449082] kvm: disabling virtualization on CPU1
[  125.449096] NOHZ: local_softirq_pending 100
[  125.546682] CPU 1 is now offline
[  125.546686] SMP alternatives: switching to UP code
[  125.878681] CPU1 is down
[  125.878799] Extended CMOS year: 2000
[  125.878799] Intel machine check architecture supported.
[  125.878799] Intel machine check reporting enabled on CPU#0.
[  125.878799] Back to C!
[  125.878799] Extended CMOS year: 2000
[  125.878799] Enabling non-boot CPUs ...
[  125.880007] SMP alternatives: switching to SMP code
[  126.064409] CPU 1 irqstacks, hard=c0b7e000 soft=c0b7a000
[  126.064411] Booting processor 1 APIC 0x1 ip 0x6000
[  125.877452] Initializing CPU#1
[  125.877452] Calibrating delay using timer specific routine.. 3663.44 BogoMIPS (lpj=6103108)
[  125.877452] CPU: L1 I cache: 32K, L1 D cache: 32K
[  125.877452] CPU: L2 cache: 2048K
[  125.877452] CPU: Physical Processor ID: 0
[  125.877452] CPU: Processor Core ID: 1
[  125.877452] Intel machine check architecture supported.
[  125.877452] Intel machine check reporting enabled on CPU#1.
[  126.157102] CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[  126.157120] kvm: enabling virtualization on CPU1
[  126.160007] Switched to high resolution mode on CPU 1
[  126.163614] CPU1 is up
[  126.163616] ACPI: Waking up from system sleep state S3
[  126.367645] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  126.377261] pcieport-driver 0000:00:01.0: restoring config space at offset 0xf (was 0x80100, writing 0x8010a)
[  126.377272] pcieport-driver 0000:00:01.0: restoring config space at offset 0xa (was 0xf, writing 0x0)
[  126.377279] pcieport-driver 0000:00:01.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x87f18001)
[  126.377286] pcieport-driver 0000:00:01.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x90309030)
[  126.377293] pcieport-driver 0000:00:01.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
[  126.377299] pcieport-driver 0000:00:01.0: restoring config space at offset 0x6 (was 0x0, writing 0x10100)
[  126.377308] pcieport-driver 0000:00:01.0: restoring config space at offset 0x3 (was 0x10000, writing 0x10040)
[  126.377316] pcieport-driver 0000:00:01.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  126.377345] pcieport-driver 0000:00:01.0: setting latency timer to 64
[  126.377358] pci 0000:00:07.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  126.377373] pci 0000:00:07.0: restoring config space at offset 0x4 (was 0x0, writing 0x90404000)
[  126.377381] pci 0000:00:07.0: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00002)
[  126.390117] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.390142] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0x90400004)
[  126.390150] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x40)
[  126.390160] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[  126.390188] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  126.390196] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  126.477521] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.477538] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x90519051)
[  126.477546] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x90209020)
[  126.477555] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[  126.477563] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x20200)
[  126.477575] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810040)
[  126.477585] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x180000, writing 0x100407)
[  126.477647] pciehp 0000:00:1c.0:pcie02: Card present on Slot(0)
[  126.477681] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  126.477689] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  126.477713] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[  126.477741] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  126.477755] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0x90109010)
[  126.477769] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[  126.477783] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0x30300)
[  126.477803] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810040)
[  126.477819] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x180000, writing 0x100407)
[  126.477881] pciehp 0000:00:1c.1:pcie02: Card present on Slot(1)
[  126.477902] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[  126.477908] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[  126.477927] pcieport-driver 0000:00:1c.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
[  126.477944] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x9 (was 0x10001, writing 0x8bf18801)
[  126.477952] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x8 (was 0x0, writing 0x90008c10)
[  126.477961] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20000000, writing 0x1010)
[  126.477969] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x6 (was 0x0, writing 0xb0400)
[  126.477981] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810040)
[  126.477991] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  126.478039] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[  126.478046] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[  126.478055] uhci_hcd 0000:00:1d.0: enabling device (0000 -> 0001)
[  126.478062] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  126.478071] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  126.478080] uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.478098] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x40a1)
[  126.478143] usb usb2: root hub lost power or was reset
[  126.478179] uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
[  126.478185] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  126.478194] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  126.478203] uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[  126.478221] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x4081)
[  126.478265] usb usb3: root hub lost power or was reset
[  126.478286] uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
[  126.478292] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  126.478301] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  126.478310] uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
[  126.478328] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x4061)
[  126.478371] usb usb4: root hub lost power or was reset
[  126.478403] uhci_hcd 0000:00:1d.3: enabling device (0000 -> 0001)
[  126.478409] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  126.478418] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  126.478427] uhci_hcd 0000:00:1d.3: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[  126.478445] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x8 (was 0x1, writing 0x4041)
[  126.478488] usb usb5: root hub lost power or was reset
[  126.490093] ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
[  126.490100] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  126.490109] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  126.490127] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.490152] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0x90405400)
[  126.490198] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[  126.490206] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0x8c008c00)
[  126.490214] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x228000f0)
[  126.490222] pci 0000:00:1e.0: restoring config space at offset 0x6 (was 0x0, writing 0x200c0c00)
[  126.490236] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  126.490372] pci 0000:00:1e.0: power state changed by ACPI to D0
[  126.490382] pci 0000:00:1e.0: setting latency timer to 64
[  126.490505] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[  126.490513] ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.490543] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
[  126.490616] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[  126.490623] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  126.490631] ata_piix 0000:00:1f.1: setting latency timer to 64
[  126.503437] ata_piix 0000:00:1f.2: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[  126.503455] ata_piix 0000:00:1f.2: restoring config space at offset 0x8 (was 0x1, writing 0x4021)
[  126.503474] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00002, writing 0x2b00007)
[  126.503494] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  126.503502] ata_piix 0000:00:1f.2: setting latency timer to 64
[  126.505773] i801_smbus 0000:00:1f.3: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[  126.505827] pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10a)
[  126.505836] pci 0000:01:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfffe0000)
[  126.505849] pci 0000:01:00.0: restoring config space at offset 0x6 (was 0x0, writing 0x90300000)
[  126.505856] pci 0000:01:00.0: restoring config space at offset 0x5 (was 0x1, writing 0x3001)
[  126.505862] pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x8, writing 0x80000008)
[  126.505869] pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x40)
[  126.505877] pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  126.505900] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  126.505906] pci 0000:01:00.0: setting latency timer to 64
[  126.516792] sky2 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.516806] sky2 0000:02:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfffe0000)
[  126.516827] sky2 0000:02:00.0: restoring config space at offset 0x6 (was 0x1, writing 0x2001)
[  126.516839] sky2 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x90200004)
[  126.516848] sky2 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x40)
[  126.516859] sky2 0000:02:00.0: restoring config space at offset 0x1 (was 0x40100000, writing 0x100407)
[  126.517001] ath5k_pci 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  126.517033] ath5k_pci 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0x90100004)
[  126.517043] ath5k_pci 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x40)
[  126.517054] ath5k_pci 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  126.530096] ath5k_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  126.543436] firewire_ohci 0000:0c:03.0: restoring config space at offset 0xf (was 0x180c0100, writing 0x180c010b)
[  126.543463] firewire_ohci 0000:0c:03.0: restoring config space at offset 0x4 (was 0x0, writing 0x8c000000)
[  126.543472] firewire_ohci 0000:0c:03.0: restoring config space at offset 0x3 (was 0x0, writing 0xf810)
[  126.543482] firewire_ohci 0000:0c:03.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900216)
[  126.580094] pciehp 0000:00:1c.0:pcie02: Device 0000:02:00.0 already exists at 0000:02:00, cannot hot-add
[  126.580099] pciehp 0000:00:1c.0:pcie02: Cannot add device at 0000:02:00
[  126.610177] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
[  126.610182] pciehp 0000:00:1c.1:pcie02: pciehp_resume ENTRY
[  126.610186] pciehp 0000:00:1c.2:pcie02: pciehp_resume ENTRY
[  126.610295] sd 2:0:1:0: [sda] Starting disk
[  126.655768] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  126.655773] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
[  126.674007] ata1.00: configured for UDMA/66
[  127.686756] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[  127.686761] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[  128.760124] ata3.01: NODEV after polling detection
[  128.760128] ata3.01: revalidation failed (errno=-2)
[  133.440417] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[  133.440422] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
[  133.504128] ata3.01: configured for UDMA/133
[  133.508864] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[  133.508902] sd 2:0:1:0: [sda] Write Protect is off
[  133.508906] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[  133.508947] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  134.304097] applesmc: device has already been initialized (0xe0, 0x00).
[  134.453427] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[  134.612841] appletouch: Geyser mode initialized.
[  134.720092] usb 4-2: reset full speed USB device using uhci_hcd and address 2
[  134.970095] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  135.331023] PM: resume devices took 8.963 seconds
[  135.331031] ------------[ cut here ]------------
[  135.331034] WARNING: at kernel/power/main.c:177 suspend_test_finish+0x51/0x57()
[  135.331038] Component: resume devices
[  135.331040] Modules linked in: ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables nf_conntrack_ftp ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ath5k mac80211 cfg80211 video [last unloaded: scsi_wait_scan]
[  135.331064] Pid: 3359, comm: pm-suspend Not tainted 2.6.28.9 #81
[  135.331068] Call Trace:
[  135.331076]  [<c043ccda>] warn_slowpath+0x5a/0x79
[  135.331082]  [<c06edab9>] usb_start_wait_urb+0x83/0x8d
[  135.331089]  [<c05eddc8>] sprintf+0x17/0x19
[  135.331095]  [<c044fcb5>] down_trylock+0x1d/0x25
[  135.331101]  [<c043d160>] try_acquire_console_sem+0xa/0x2a
[  135.331107]  [<c04445bf>] try_to_del_timer_sync+0x44/0x4a
[  135.331113]  [<c06eee1e>] usb_autopm_do_device+0xaa/0xb1
[  135.331118]  [<c089989f>] printk+0xe/0x11
[  135.331124]  [<c045bbb9>] suspend_test_finish+0x51/0x57
[  135.331129]  [<c045bd0f>] suspend_devices_and_enter+0x150/0x17a
[  135.331135]  [<c045be87>] enter_state+0x12d/0x189
[  135.331140]  [<c045bf6a>] state_store+0x87/0x9a
[  135.331145]  [<c045bee3>] state_store+0x0/0x9a
[  135.331151]  [<c05e9e4f>] kobj_attr_store+0x18/0x1c
[  135.331156]  [<c04d27aa>] sysfs_write_file+0xb0/0xdd
[  135.331161]  [<c04d26fa>] sysfs_write_file+0x0/0xdd
[  135.331167]  [<c04989d5>] vfs_write+0x84/0x121
[  135.331171]  [<c0498b0a>] sys_write+0x3c/0x63
[  135.331176]  [<c041a8a1>] sysenter_do_call+0x12/0x21
[  135.331183]  [<c0890000>] i2o_pci_probe+0x14c/0x587
[  135.331186] ---[ end trace 48a18987b664088c ]---
[  135.343011] PM: Finishing wakeup.
[  135.343014] Restarting tasks ... done.
[  135.418615] sd 4:0:0:0: [sdb] Unit Not Ready
[  135.418710] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  135.418956] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  135.420033] sd 4:0:0:1: [sdc] Unit Not Ready
[  135.420124] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  135.420371] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  135.427497] sd 4:0:0:2: [sdd] Unit Not Ready
[  135.427590] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  135.427942] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  135.431741] sd 4:0:0:3: [sde] Unit Not Ready
[  135.431834] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  135.432080] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  135.437506] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  135.437619] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  135.437770] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  135.438013] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  135.448874] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  135.448971] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  135.456623] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  135.456735] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  135.456877] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  135.457117] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  135.459616] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  135.459712] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  135.493144] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  135.493239] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  135.493404] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  135.493647] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  135.495402] sd 4:0:0:3: [sde] READ CAPACITY failed
[  135.495509] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  135.495755] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  135.495998] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  135.500140] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  135.500235] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  135.503257] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  135.503370] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  135.512631] sd 4:0:0:1: [sdc] Unit Not Ready
[  135.512724] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  135.512967] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  135.525129] sd 4:0:0:0: [sdb] Unit Not Ready
[  135.525220] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  135.525463] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  135.532132] sd 4:0:0:2: [sdd] Unit Not Ready
[  135.532231] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  135.532472] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  135.536186] sd 4:0:0:3: [sde] Unit Not Ready
[  135.536302] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  135.536575] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  135.550006] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  135.550101] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  135.550243] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  135.550486] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  135.554149] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  135.554291] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  135.562130] sd 4:0:0:3: [sde] READ CAPACITY failed
[  135.562226] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  135.562370] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  135.562614] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  135.563878] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  135.563969] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  135.564112] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  135.564371] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  135.569507] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  135.569598] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  135.569740] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  135.569984] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  135.573759] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  135.573856] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  135.575005] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  135.575102] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  135.584643] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  135.584741] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  138.013482] sky2 eth0: enabling interface
[  138.013796] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  138.028834] [drm] Loading R500 Microcode
[  138.028897] [drm] Num pipes: 1
[  138.054891] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  138.167698] sd 4:0:0:0: [sdb] Unit Not Ready
[  138.167705] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  138.167713] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  138.177730] sd 4:0:0:2: [sdd] Unit Not Ready
[  138.177738] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  138.177746] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  138.189841] sd 4:0:0:3: [sde] Unit Not Ready
[  138.189849] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  138.189856] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  138.190711] sd 4:0:0:1: [sdc] Unit Not Ready
[  138.190715] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  138.190722] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  138.237080] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  138.237088] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  138.237094] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  138.237101] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  138.244704] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  138.244709] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  138.244715] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  138.244722] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  138.245827] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  138.245833] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  138.253078] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  138.253084] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  138.255202] sd 4:0:0:3: [sde] READ CAPACITY failed
[  138.255207] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  138.255213] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  138.255219] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  138.256326] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  138.256331] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  138.256337] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  138.256343] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  138.264840] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  138.264848] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  138.265837] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  138.265842] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  138.276980] sd 4:0:0:0: [sdb] Unit Not Ready
[  138.276987] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  138.276995] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  138.286837] sd 4:0:0:2: [sdd] Unit Not Ready
[  138.286844] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  138.286851] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  138.298751] sd 4:0:0:1: [sdc] Unit Not Ready
[  138.298759] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  138.298767] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  138.299587] sd 4:0:0:3: [sde] Unit Not Ready
[  138.299592] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  138.299599] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  138.314868] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  138.314875] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  138.314882] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  138.314889] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  138.326058] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  138.326066] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  138.326072] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  138.326080] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  138.347388] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  138.347397] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  138.348824] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  138.348829] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  138.348836] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  138.348843] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  138.350087] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  138.350093] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  138.351797] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  138.351804] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  138.352824] sd 4:0:0:3: [sde] READ CAPACITY failed
[  138.352829] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  138.352835] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  138.352842] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  138.353948] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  138.353953] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  139.902536] sd 4:0:0:1: [sdc] Unit Not Ready
[  139.902543] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  139.902550] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  139.908910] sd 4:0:0:2: [sdd] Unit Not Ready
[  139.908914] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  139.908921] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  139.909771] sd 4:0:0:3: [sde] Unit Not Ready
[  139.909776] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  139.909783] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  139.910772] sd 4:0:0:0: [sdb] Unit Not Ready
[  139.910776] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  139.910783] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  139.926023] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  139.926030] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  139.926036] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  139.926042] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  139.927136] sd 4:0:0:3: [sde] READ CAPACITY failed
[  139.927140] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  139.927146] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  139.927152] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  139.928275] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  139.928280] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  139.934267] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  139.934273] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  139.936413] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  139.936418] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  139.936424] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  139.936431] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  139.942673] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  139.942679] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  139.942686] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  139.942693] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  139.944791] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  139.944797] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  139.951415] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  139.951421] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  139.952398] sd 4:0:0:0: [sdb] Unit Not Ready
[  139.952403] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  139.952410] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  139.953273] sd 4:0:0:3: [sde] Unit Not Ready
[  139.953277] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  139.953283] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  139.971016] sd 4:0:0:1: [sdc] Unit Not Ready
[  139.971020] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  139.971027] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  139.979640] sd 4:0:0:2: [sdd] Unit Not Ready
[  139.979644] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  139.979651] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  139.981523] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  139.981529] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  139.981535] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  139.981542] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  139.982647] sd 4:0:0:3: [sde] READ CAPACITY failed
[  139.982651] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  139.982656] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  139.982662] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  139.989771] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  139.989776] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  139.991023] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  139.991028] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  139.998038] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  139.998042] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  139.998048] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  139.998054] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  140.002790] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  140.002794] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  140.002799] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  140.002806] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  140.003914] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  140.003919] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  140.008676] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  140.008681] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  141.902975] sd 4:0:0:2: [sdd] Unit Not Ready
[  141.902982] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  141.902990] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  141.903847] sd 4:0:0:1: [sdc] Unit Not Ready
[  141.903851] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  141.903857] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  141.917462] sd 4:0:0:0: [sdb] Unit Not Ready
[  141.917467] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  141.917475] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  141.918336] sd 4:0:0:3: [sde] Unit Not Ready
[  141.918340] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  141.918347] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  141.925726] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  141.925730] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  141.925736] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  141.925743] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  141.926851] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  141.926855] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  141.926860] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  141.926866] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  141.933978] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  141.933983] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  141.935227] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  141.935232] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  141.944835] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  141.944840] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  141.944846] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  141.944852] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  141.953345] sd 4:0:0:3: [sde] READ CAPACITY failed
[  141.953350] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  141.953355] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  141.953362] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  141.954460] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  141.954464] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  141.955585] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  141.955590] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  141.962082] sd 4:0:0:2: [sdd] Unit Not Ready
[  141.962087] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  141.962094] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  141.964964] sd 4:0:0:1: [sdc] Unit Not Ready
[  141.964968] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  141.964975] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  141.976708] sd 4:0:0:0: [sdb] Unit Not Ready
[  141.976715] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  141.976722] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  141.983589] sd 4:0:0:3: [sde] Unit Not Ready
[  141.983594] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  141.983601] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  141.990730] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  141.990735] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  141.990741] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  141.990748] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  141.991854] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  141.991859] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  141.991864] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  141.991871] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  141.996606] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  141.996612] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  141.999980] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  141.999985] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  142.001071] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  142.001076] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  142.001082] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  142.001089] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  142.002216] sd 4:0:0:3: [sde] READ CAPACITY failed
[  142.002220] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  142.002226] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  142.002232] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  142.003365] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  142.003372] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  142.004719] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  142.004724] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  143.897645] sd 4:0:0:1: [sdc] Unit Not Ready
[  143.897653] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  143.897660] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  143.906153] sd 4:0:0:2: [sdd] Unit Not Ready
[  143.906160] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  143.906168] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  143.913879] sd 4:0:0:3: [sde] Unit Not Ready
[  143.913884] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  143.913891] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  143.915875] sd 4:0:0:0: [sdb] Unit Not Ready
[  143.915879] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  143.915886] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  143.918128] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  143.918133] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  143.918139] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  143.918145] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  143.926132] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  143.926139] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  143.932033] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  143.932040] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  143.932046] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  143.932053] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  143.933201] sd 4:0:0:3: [sde] READ CAPACITY failed
[  143.933209] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  143.933215] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  143.933222] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  143.940404] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  143.940412] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  143.940418] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  143.940425] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  143.941523] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  143.941528] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  143.943389] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  143.943394] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  143.945144] sd 4:0:0:1: [sdc] Unit Not Ready
[  143.945148] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  143.945155] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  143.950036] sd 4:0:0:3: [sde] Unit Not Ready
[  143.950041] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  143.950052] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  143.950341] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  143.950347] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  143.952149] sd 4:0:0:0: [sdb] Unit Not Ready
[  143.952154] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  143.952160] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  143.960899] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  143.960905] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  143.960910] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  143.960917] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  143.971032] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  143.971040] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  143.973273] sd 4:0:0:3: [sde] READ CAPACITY failed
[  143.973277] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  143.973283] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  143.973290] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  143.974397] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  143.974401] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  143.974407] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  143.974413] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  143.975522] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  143.975527] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  143.976644] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  143.976649] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  143.985407] sd 4:0:0:2: [sdd] Unit Not Ready
[  143.985415] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  143.985422] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  144.007660] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  144.007667] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  144.007673] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  144.007680] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  144.012528] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  144.012536] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  145.907711] sd 4:0:0:0: [sdb] Unit Not Ready
[  145.907719] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  145.907727] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  145.908583] sd 4:0:0:3: [sde] Unit Not Ready
[  145.908588] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  145.908594] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  145.909457] sd 4:0:0:1: [sdc] Unit Not Ready
[  145.909461] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  145.909467] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  145.910175] sd 4:0:0:2: [sdd] Unit Not Ready
[  145.910180] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  145.910187] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  145.931715] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  145.931723] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  145.931729] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  145.931736] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  145.932820] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  145.932825] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  145.932831] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  145.932837] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  145.934324] sd 4:0:0:3: [sde] READ CAPACITY failed
[  145.934328] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  145.934334] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  145.934340] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  145.940200] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  145.940206] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  145.940212] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  145.940218] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  145.940239] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  145.940246] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  145.941324] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  145.941329] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  145.942446] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  145.942451] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  145.943576] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  145.943582] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  145.969461] sd 4:0:0:0: [sdb] Unit Not Ready
[  145.969468] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  145.969475] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  145.970326] sd 4:0:0:3: [sde] Unit Not Ready
[  145.970331] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  145.970337] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  145.970570] sd 4:0:0:2: [sdd] Unit Not Ready
[  145.970575] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  145.970582] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  145.971212] sd 4:0:0:1: [sdc] Unit Not Ready
[  145.971217] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  145.971223] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  145.991613] sd 4:0:0:2: [sdd] READ CAPACITY failed
[  145.991620] sd 4:0:0:2: [sdd] Result: hostbyte=0x00 driverbyte=0x08
[  145.991627] sd 4:0:0:2: [sdd] Sense Key : 0x5 [current] 
[  145.991639] sd 4:0:0:2: [sdd] ASC=0x25 ASCQ=0x0
[  145.993838] sd 4:0:0:0: [sdb] READ CAPACITY failed
[  145.993843] sd 4:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
[  145.993849] sd 4:0:0:0: [sdb] Sense Key : 0x5 [current] 
[  145.993856] sd 4:0:0:0: [sdb] ASC=0x25 ASCQ=0x0
[  145.999838] sd 4:0:0:3: [sde] READ CAPACITY failed
[  145.999843] sd 4:0:0:3: [sde] Result: hostbyte=0x00 driverbyte=0x08
[  145.999849] sd 4:0:0:3: [sde] Sense Key : 0x5 [current] 
[  145.999856] sd 4:0:0:3: [sde] ASC=0x25 ASCQ=0x0
[  146.001466] sd 4:0:0:1: [sdc] READ CAPACITY failed
[  146.001471] sd 4:0:0:1: [sdc] Result: hostbyte=0x00 driverbyte=0x08
[  146.001477] sd 4:0:0:1: [sdc] Sense Key : 0x5 [current] 
[  146.001483] sd 4:0:0:1: [sdc] ASC=0x25 ASCQ=0x0
[  146.002588] sd 4:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  146.002594] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  146.003417] sd 4:0:0:2: [sdd] Test WP failed, assume Write Enabled
[  146.003423] sd 4:0:0:2: [sdd] Assuming drive cache: write through
[  146.004095] sd 4:0:0:3: [sde] Test WP failed, assume Write Enabled
[  146.004101] sd 4:0:0:3: [sde] Assuming drive cache: write through
[  146.005215] sd 4:0:0:1: [sdc] Test WP failed, assume Write Enabled
[  146.005220] sd 4:0:0:1: [sdc] Assuming drive cache: write through
[  146.729407] usb 1-1: USB disconnect, address 6
[  146.729414] usb 1-1.1: USB disconnect, address 7
[  146.731872] usb 1-1.3: USB disconnect, address 8
[  146.807089] usb 1-1.4: USB disconnect, address 9
[  150.173803] wlan0: authenticate with AP 00:23:08:1d:f2:bb
[  150.192457] wlan0: authenticate with AP 00:23:08:1d:f2:bb
[  150.199256] wlan0: authenticated
[  150.199262] wlan0: associate with AP 00:23:08:1d:f2:bb
[  150.227542] wlan0: RX AssocResp from 00:23:08:1d:f2:bb (capab=0x431 status=0 aid=2)
[  150.227548] wlan0: associated
[  150.228593] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  160.440024] wlan0: no IPv6 routers present


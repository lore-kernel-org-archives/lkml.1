Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZCBPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZCBPsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZCBPso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:48:44 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:60981 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZCBPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=qOfkxe+0gkeIIoQPuTqnLzDcABhIktVNqA2W+aIKR1l9FKkUquKCccDJwTXYXTx6eN
         YgG4BhDsaA1UslGqMKSZV5RASooXDiER0JgxUSrYbCP2RDZm0qOX9bPU0wkfdSs9Pg8b
         7MPsOpj068rioZSr3SGjsLtJkH4do2hj2AEow=
Message-ID: <49ABFFCF.5090106@gmail.com>
Date: Mon, 02 Mar 2009 16:48:31 +0100
From: Enrico Tagliavini <enrico.tagliavini@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sis190 issue
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

With recent kernel >=2.6.27 i can't make large file transfert (via any
protocol) with my local server anymore. The file transfer begin and after some
seconds (sometimes minutes) it hangs on and i can't connect to my home server
anymore even if i reboot my pc! But internet still works (i can connect to my
home server using external ip, but not with local one).

For example with nfs, nfsiod freeze and can't be even killed!

i suspect (but not sure) that kernel kills my lan eth, or can't handle it
correctly. But if i boot windows it can connect to my home server. so i reboot
in linux but still no connection!

i'm using a Silicon Integrated Systems [SiS] 191 Gigabit Ethernet Adapter (rev
02) on a asus f5sl-ap247e notebook. here some stuff (if you need more info just ask :D). Thanks for the help :D

Reproducible: Always

Steps to Reproduce:
1. make large file transfer from my home server to this pc

this is the output of lspci -v
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 671MX
        Subsystem: Silicon Integrated Systems [SiS] 671MX  
        Flags: bus master, medium devsel, latency 64       

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge (prog-if
00 [Normal decode])
        Flags: bus master, fast devsel, latency 0                               
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0            
        I/O behind bridge: 0000d000-0000dfff                                    
        Memory behind bridge: fde00000-fdefffff                                 
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff    
        Capabilities: <access denied>                                           
        Kernel driver in use: pcieport-driver                                   

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS968 [MuTIOL Media IO]
(rev 01)
        Flags: bus master, medium devsel, latency 0                             

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev 01)
(prog-if 80 [Master])
        Subsystem: ASUSTeK Computer Inc. Device 19e7                            
        Flags: bus master, medium devsel, latency 128                           
        I/O ports at 01f0 [size=8]                                              
        I/O ports at 03f4 [size=1]                                              
        I/O ports at 0170 [size=8]                                              
        I/O ports at 0374 [size=1]                                              
        I/O ports at ffe0 [size=16]                                             
        Capabilities: <access denied>                                           
        Kernel driver in use: SIS_IDE                                           

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 Controller
(rev 0f) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 19e7                            
        Flags: bus master, medium devsel, latency 64, IRQ 20                    
        Memory at fddff000 (32-bit, non-prefetchable) [size=4K]                 
        Kernel driver in use: ohci_hcd                                          
        Kernel modules: ohci-hcd                                                

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1 Controller
(rev 0f) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Device 19e7                            
        Flags: bus master, medium devsel, latency 64, IRQ 21                    
        Memory at fddfe000 (32-bit, non-prefetchable) [size=4K]                 
        Kernel driver in use: ohci_hcd                                          
        Kernel modules: ohci-hcd                                                

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
(prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Device 19e7                            
        Flags: bus master, medium devsel, latency 64, IRQ 22                    
        Memory at fddfd000 (32-bit, non-prefetchable) [size=4K]                 
        Capabilities: <access denied>                                           
        Kernel driver in use: ehci_hcd                                          
        Kernel modules: ehci-hcd                                                

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] 191 Gigabit
Ethernet Adapter (rev 02)
        Subsystem: ASUSTeK Computer Inc. Device 1815                            
        Flags: bus master, medium devsel, latency 0, IRQ 19                     
        Memory at fddfcc00 (32-bit, non-prefetchable) [size=128]                
        I/O ports at cc00 [size=128]                                            
        Capabilities: <access denied>                                           
        Kernel driver in use: sis190                                            
        Kernel modules: sis190                                                  

00:05.0 IDE interface: Silicon Integrated Systems [SiS] SATA Controller / IDE
mode (rev 03) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device 19e7                            
        Flags: bus master, medium devsel, latency 64, IRQ 17                    
        I/O ports at c800 [size=8]                                              
        I/O ports at c400 [size=4]                                              
        I/O ports at c000 [size=8]                                              
        I/O ports at bc00 [size=4]                                              
        I/O ports at b800 [size=16]                                             
        I/O ports at b400 [size=128]                                            
        Capabilities: <access denied>                                           
        Kernel driver in use: sata_sis                                          

00:06.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge (prog-if
00 [Normal decode])
        Flags: bus master, fast devsel, latency 0                               
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0            
        Memory behind bridge: fdf00000-fdffffff                                 
        Capabilities: <access denied>                                           
        Kernel driver in use: pcieport-driver                                   

00:07.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge (prog-if
00 [Normal decode])
        Flags: bus master, fast devsel, latency 0                               
        Bus: primary=00, secondary=03, subordinate=05, sec-latency=0            
        I/O behind bridge: 0000e000-0000efff                                    
        Memory behind bridge: fe000000-febfffff                                 
        Prefetchable memory behind bridge: 00000000fa000000-00000000fcffffff    
        Capabilities: <access denied>                                           
        Kernel driver in use: pcieport-driver                                   

00:0f.0 Audio device: Silicon Integrated Systems [SiS] Azalia Audio Controller
        Subsystem: ASUSTeK Computer Inc. Device 1783                          
        Flags: bus master, medium devsel, latency 0, IRQ 18                   
        Memory at fddf8000 (32-bit, non-prefetchable) [size=16K]              
        Capabilities: <access denied>                                         
        Kernel driver in use: HDA Intel                                       

01:00.0 VGA compatible controller: ATI Technologies Inc Mobilitiy Radeon HD
3400 Series (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 19e2
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        I/O ports at d800 [size=256]
        Memory at fdef0000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at fdec0000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: fglrx_pci
        Kernel modules: fglrx

02:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg
Wireless PCI Express Adapter (rev 01)
        Subsystem: Device 1a3b:1026
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: ath5k_pci
        Kernel modules: ath5k

and ifconfig show some  errors in packet RX

etho      Link encap:Ethernet  HWaddr 00:23:54:88:84:9b                         
          inet addr:192.168.0.102  Bcast:192.168.0.255  Mask:255.255.255.0      
          inet6 addr: fe80::223:54ff:fe88:849b/64 Scope:Link                    
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1                    
          RX packets:2090 errors:33 dropped:0 overruns:0 frame:33               
          TX packets:1284 errors:0 dropped:0 overruns:0 carrier:0               
          collisions:0 txqueuelen:1000                                          
          RX bytes:867585 (847.2 KiB)  TX bytes:267799 (261.5 KiB)              
          Interrupt:19 Base address:0xdead


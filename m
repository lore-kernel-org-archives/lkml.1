Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0BOJxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:53:53 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43323 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0BOJxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:53:52 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm
Date: Mon, 15 Feb 2010 10:53:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-prerelease; KDE/4.3.4; x86_64; ; )
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151053.48681.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 11 Februar 2010 05:20:07 schrieb Dave Airlie:

Dave,

I just updated from to rc8 and got the a scheduling while atomic warning in
nouveau. (see below).

...
[    0.298265] [drm] Initialized drm 1.1.0 20060810                                                                                                                         
[    0.298409] nouveau 0000:01:00.0: power state changed by ACPI to D0                                                                                                      
[    0.298420] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                                                             
[    0.298426] nouveau 0000:01:00.0: setting latency timer to 64                                                                                                            
[    0.301746] [drm] nouveau 0000:01:00.0: failed to evaluate _DSM: 5                                                                                                       
[    0.303750] ACPI: Battery Slot [BAT0] (battery present)                                                                                                                  
[    0.304515] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x084c00a2)                                                                                    
[    0.305534] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN                                                                                        
[    0.382604] [drm] nouveau 0000:01:00.0: ... appears to be valid                                                                                                          
[    0.382607] [drm] nouveau 0000:01:00.0: BIT BIOS found                                                                                                                   
[    0.382609] [drm] nouveau 0000:01:00.0: Bios version 60.84.51.00                                                                                                         
[    0.382613] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not currently supported                                                                                  
[    0.382614] [drm] nouveau 0000:01:00.0: BIT table 'd' not found                                                                                                          
[    0.382616] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0                                                                                    
[    0.382619] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 14 2                                                                                            
[    0.382621] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff                                                                                        
[    0.382623] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff                                                                                        
[    0.382626] [drm] nouveau 0000:01:00.0:   2: 0x00001231: type 0x31 idx 2 tag 0x07                                                                                        
[    0.382628] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034                                                                                               
[    0.382630] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02811300 00000028                                                                                               
[    0.382632] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02822312 00010030                                                                                               
[    0.382633] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000                                                                                               
[    0.382641] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xDEBB                                                                                      
[    0.420125] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xE208                                                                                      
[    0.453350] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEC55                                                                                      
[    0.453358] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xED47                                                                                      
[    0.460091] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEF7A                                                                                      
[    0.460093] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEFDF                                                                                        
[    0.483353] [drm] nouveau 0000:01:00.0: 0xEFDF: Condition still not met after 20ms, skipping following opcodes                                                           
[    0.483360] [drm] nouveau 0000:01:00.0: 0xD01A: parsing output script 0                                                                                                  
[    0.483362] [drm] nouveau 0000:01:00.0: 0xD190: parsing output script 0                                                                                                  
[    0.600743] [TTM] Zone  kernel: Available graphics memory: 1993568 kiB.                                                                                                  
[    0.600755] [drm] nouveau 0000:01:00.0: 256 MiB VRAM                                                                                                                     
[    0.632525] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)                                                                                                          
[    0.632531] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining                                                                               
[    0.632541] nouveau 0000:01:00.0: firmware: using built-in firmware nouveau/nv84.ctxprog                                                                                 
[    0.632545] nouveau 0000:01:00.0: firmware: using built-in firmware nouveau/nv84.ctxvals                                                                                 
[    0.632801] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1                                                                                                         
[    0.640758] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1                                                                                        
[    0.641523] [drm] nouveau 0000:01:00.0: Detected a LVDS output                                                                                                           
[    0.641527] [drm] nouveau 0000:01:00.0: Detected a DAC output                                                                                                            
[    0.641529] [drm] nouveau 0000:01:00.0: Detected a TMDS output                                                                                                           
[    0.641531] [drm] nouveau 0000:01:00.0: Detected a LVDS connector                                                                                                        
[    0.741133] [drm] nouveau 0000:01:00.0: Detected a VGA connector                                                                                                         
[    0.741222] [drm] nouveau 0000:01:00.0: Detected a DVI-D connector                                                                                                       
[    2.173573] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x40250000, bo ffff88013b9c5800                                                                          
[    2.175406] [drm] nouveau 0000:01:00.0: 0xD01E: parsing output script 1                                                                                                  
[    2.175431] [drm] nouveau 0000:01:00.0: 0xCEC7: parsing clock script 0                                                                                                   
[    2.175437] BUG: scheduling while atomic: nouveau/0/753/0x00000002                                                                                                       
[    2.175439] Modules linked in:                                                                                                                                           
[    2.175442] Pid: 753, comm: nouveau/0 Not tainted 2.6.33-rc8-prerelease #27                                                                                              
[    2.175443] Call Trace:                                                                                                                                                  
[    2.175451]  [<ffffffff815dcdea>] ? schedule+0x86a/0x880                                                                                                                 
[    2.175454]  [<ffffffff8120a420>] ? vsnprintf+0xe0/0x9a0                                                                                                                 
[    2.175456]  [<ffffffff815dd18c>] ? schedule_timeout+0x15c/0x250                                                                                                         
[    2.175460]  [<ffffffff81068570>] ? process_timeout+0x0/0x10                                                                                                             
[    2.175462]  [<ffffffff81069068>] ? msleep+0x18/0x30                                                                                                                     
[    2.175466]  [<ffffffff812d48d1>] ? init_time+0x51/0x90                                                                                                                  
[    2.175468]  [<ffffffff812d3ffb>] ? parse_init_table+0xcb/0x1a0                                                                                                          
[    2.175470]  [<ffffffff812d424a>] ? init_sub_direct+0x4a/0xd0                                                                                                            
[    2.175472]  [<ffffffff812d3ffb>] ? parse_init_table+0xcb/0x1a0                                                                                                          
[    2.175474]  [<ffffffff812d496f>] ? nouveau_bios_run_init_table+0x5f/0xa0                                                                                                
[    2.175476]  [<ffffffff812d4c0c>] ? nouveau_bios_run_display_table+0x25c/0x500                                                                                           
[    2.175480]  [<ffffffff812fd220>] ? nv50_display_irq_handler_bh+0x0/0x410                                                                                                
[    2.175483]  [<ffffffff812fd4cc>] ? nv50_display_irq_handler_bh+0x2ac/0x410                                                                                              
[    2.175485]  [<ffffffff812fd220>] ? nv50_display_irq_handler_bh+0x0/0x410                                                                                                
[    2.175487]  [<ffffffff8107047b>] ? worker_thread+0x16b/0x250                                                                                                            
[    2.175490]  [<ffffffff81074240>] ? autoremove_wake_function+0x0/0x30                                                                                                    
[    2.175492]  [<ffffffff81070310>] ? worker_thread+0x0/0x250                                                                                                              
[    2.175494]  [<ffffffff81070310>] ? worker_thread+0x0/0x250                                                                                                              
[    2.175496]  [<ffffffff81073dbe>] ? kthread+0x8e/0xa0                                                                                                                    
[    2.175499]  [<ffffffff81027554>] ? kernel_thread_helper+0x4/0x10                                                                                                        
[    2.175501]  [<ffffffff81073d30>] ? kthread+0x0/0xa0                                                                                                                     
[    2.175503]  [<ffffffff81027550>] ? kernel_thread_helper+0x0/0x10                                                                                                        
[    2.182407] Console: switching to colour frame buffer device 240x75                                                                                                      
[    2.186632] fb0: nouveaufb frame buffer device                                                                                                                           
[    2.186633] registered panic notifier                                                                                                                                    
[    2.186636] [drm] Initialized nouveau 0.0.15 20090420 for 0000:01:00.0 on minor 0  
...

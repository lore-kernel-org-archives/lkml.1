Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZGGLtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZGGLtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZGGLtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:49:43 -0400
Received: from smtp4.usinternet.com ([216.17.3.201]:59641 "EHLO
	smtp4.usinternet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZGGLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:49:37 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2009 07:49:36 EDT
Message-ID: <4A533378.7060607@netwolves.com>
Date: Tue, 07 Jul 2009 07:37:28 -0400
From: Phillip Lynn <phillip.lynn@netwolves.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel error "kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2136!"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This weekend I was trying to us Google Earth and received the following 
kernel error.  I have not posted to the group before so if this is not 
the correct address to send an error please let me know.

Thank You
Phillip Lynn


Jul  6 20:03:32 plynn54 kernel: ------------[ cut here ]------------
Jul  6 20:03:32 plynn54 kernel: kernel BUG at 
drivers/gpu/drm/i915/i915_gem.c:2136!
Jul  6 20:03:32 plynn54 kernel: invalid opcode: 0000 [#1] SMP
Jul  6 20:03:32 plynn54 kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/local_cpus
Jul  6 20:03:32 plynn54 kernel: CPU 1
Jul  6 20:03:32 plynn54 kernel: Modules linked in: fuse nfsd lockd 
nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap bluetooth 
coretemp w83627ehf hwmon_vid hwmon sunrpc ipv6 cpufreq_ondemand 
acpi_cpufreq freq_table dm_multipath uinput snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep e100 snd_pcm firewire_ohci 
snd_timer i2c_i801 firewire_core crc_itu_t e1000e mii snd soundcore 
snd_page_alloc pata_jmicron iTCO_wdt iTCO_vendor_support pcspkr 
ata_generic pata_acpi i915 drm i2c_algo_bit i2c_core video output [last 
unloaded: microcode]
Jul  6 20:03:32 plynn54 kernel: Pid: 9470, comm: googleearth-bin Not 
tainted 2.6.29.5-191.fc11.x86_64 #1
Jul  6 20:03:32 plynn54 kernel: RIP: 0010:[<ffffffffa005f3d2>]  
[<ffffffffa005f3d2>] i915_gem_object_get_fence_reg+0x221/0x61e [i915]
Jul  6 20:03:32 plynn54 kernel: RSP: 0000:ffff8801f3cb1be8  EFLAGS: 00010202
Jul  6 20:03:32 plynn54 kernel: RAX: 000000000007bbc3 RBX: 
ffff8801c01eae40 RCX: 0000000000000010
Jul  6 20:03:32 plynn54 kernel: RDX: 0000000000002982 RSI: 
000000000007bbc3 RDI: ffff8801c01ae000
Jul  6 20:03:32 plynn54 kernel: RBP: ffff8801f3cb1c28 R08: 
0000000000000004 R09: ffff88022c96b1f0
Jul  6 20:03:32 plynn54 kernel: R10: ffff8801f3cb0000 R11: 
ffff8801f3cb1d38 R12: ffff88021a811d80
Jul  6 20:03:32 plynn54 kernel: R13: ffff88022c96b000 R14: 
ffff8801c01eacc0 R15: ffff88022c96a000
Jul  6 20:03:32 plynn54 kernel: FS:  0000000000000000(0000) 
GS:ffff88022e43e480(0063) knlGS:00000000f7faa700
Jul  6 20:03:32 plynn54 kernel: CS:  0010 DS: 002b ES: 002b CR0: 
0000000080050033
Jul  6 20:03:32 plynn54 kernel: CR2: 00000000ebe2e000 CR3: 
00000001c0057000 CR4: 00000000000006e0
Jul  6 20:03:32 plynn54 kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jul  6 20:03:32 plynn54 kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jul  6 20:03:32 plynn54 kernel: Process googleearth-bin (pid: 9470, 
threadinfo ffff8801f3cb0000, task ffff8801c00bc500)
Jul  6 20:03:32 plynn54 kernel: Stack:
Jul  6 20:03:32 plynn54 kernel: ffff8801f3cb1c38 ffff88022c96b1f0 
ffff88022c96a020 ffff8801c01eacc0
Jul  6 20:03:32 plynn54 kernel: ffff88022c96a020 ffff8801c01eae40 
ffff8801f4d64210 ffff8801f3cb1ce8
Jul  6 20:03:32 plynn54 kernel: ffff8801f3cb1c98 ffffffffa00610d3 
ffff8801f3cb1c68 00000000ebe2e000
Jul  6 20:03:32 plynn54 kernel: Call Trace:
Jul  6 20:03:32 plynn54 kernel: [<ffffffffa00610d3>] 
i915_gem_fault+0xc1/0x136 [i915]
Jul  6 20:03:32 plynn54 kernel: [<ffffffff810b213f>] __do_fault+0x55/0x3d5
Jul  6 20:03:32 plynn54 kernel: [<ffffffffa0029305>] ? 
drm_agp_bind_memory+0x18/0x1a [drm]
Jul  6 20:03:32 plynn54 kernel: [<ffffffffa00295dc>] ? 
drm_agp_bind_pages+0xd8/0x10c [drm]
Jul  6 20:03:32 plynn54 kernel: [<ffffffff810b4475>] 
handle_mm_fault+0x349/0x7c5
Jul  6 20:03:32 plynn54 kernel: [<ffffffff813ae615>] 
do_page_fault+0x5b5/0x9e9
Jul  6 20:03:32 plynn54 kernel: [<ffffffff8103a0e9>] ? 
__dequeue_entity+0x33/0x38
Jul  6 20:03:32 plynn54 kernel: [<ffffffff813ac01a>] ? 
unlock_kernel+0x2f/0x32
Jul  6 20:03:32 plynn54 kernel: [<ffffffffa006f42f>] ? 
i915_compat_ioctl+0x74/0x81 [i915]
Jul  6 20:03:32 plynn54 kernel: [<ffffffff8110a0d7>] ? 
compat_sys_ioctl+0x352/0x367
Jul  6 20:03:32 plynn54 kernel: [<ffffffff813abab5>] ? 
trace_hardirqs_off_thunk+0x3a/0x6c
Jul  6 20:03:32 plynn54 kernel: [<ffffffff813ac175>] page_fault+0x25/0x30
Jul  6 20:03:32 plynn54 kernel: Code: ff e8 35 e9 ff ff 85 c0 0f 84 b3 
fe ff ff e9 06 04 00 00 41 83 7c 24 20 00 75 10 48 8b 55 c8 48 8b 02 f7 
40 70 be ff ff ff 74 04 <0f> 0b eb fe 49 8b bf 38 01 00 00 48 8b 70 38 
48 85 ff 74 1a 48
Jul  6 20:03:32 plynn54 kernel: RIP  [<ffffffffa005f3d2>] 
i915_gem_object_get_fence_reg+0x221/0x61e [i915]
Jul  6 20:03:32 plynn54 kernel: RSP <ffff8801f3cb1be8>
Jul  6 20:03:32 plynn54 kernel: ---[ end trace 5745c84a41a3540a ]---
Jul  6 20:04:14 plynn54 mountd[1829]: Caught signal 15, un-registering 
and exiting.
Jul  6 20:04:14 plynn54 kernel: nfsd: last server has exited, flushing 
export cache
Jul  6 20:04:18 plynn54 init: prefdm main process (2164) killed by KILL 
signal
Jul  6 20:04:45 plynn54 squid[2056]: Squid Parent: child process 2059 
exited with status 0
Jul  6 20:04:49 plynn54 xinetd[1764]: Exiting...
Jul  6 20:04:49 plynn54 acpid: exiting
Jul  6 20:04:49 plynn54 NetworkManager: <info>  HAL disappeared
Jul  6 20:04:49 plynn54 pcscd: pcscdaemon.c:581:signal_trap() Preparing 
for suicide
Jul  6 20:04:50 plynn54 pcscd: readerfactory.c:1242:RFCleanupReaders() 
entering cleaning function
Jul  6 20:04:50 plynn54 pcscd: pcscdaemon.c:531:at_exit() cleaning /var/run
Jul  6 20:04:50 plynn54 bluetoothd[1695]: bridge pan0 removed
Jul  6 20:04:50 plynn54 bluetoothd[1695]: Stopping SDP server
Jul  6 20:04:50 plynn54 bluetoothd[1695]: Exit
Jul  6 20:04:50 plynn54 NetworkManager: <WARN>  nm_signal_handler(): 
Caught signal 15, shutting down normally.
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth1): now unmanaged
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth1): device state 
change: 2 -> 1
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth1): cleaning up...
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth1): taking down device.
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth0): now unmanaged
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth0): device state 
change: 8 -> 1
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth0): deactivating 
device (reason: 36).
Jul  6 20:04:50 plynn54 NetworkManager: <WARN>  check_one_route(): 
(eth0) error -34 returned from rtnl_route_del(): Sucess#012
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth0): cleaning up...
Jul  6 20:04:50 plynn54 NetworkManager: <info>  (eth0): taking down device.
Jul  6 20:04:51 plynn54 NetworkManager: <info>  exiting (success)
Jul  6 20:04:52 plynn54 nm-system-settings: disconnected from the system 
bus, exiting.
Jul  6 20:04:52 plynn54 nm-dispatcher.action: Disconnected from the 
system bus, exiting.
Jul  6 20:04:52 plynn54 rpc.statd[1384]: Caught signal 15, 
un-registering and exiting.
Jul  6 20:04:52 plynn54 rpcbind: rpcbind terminating on signal. Restart 
with "rpcbind -w"
Jul  6 20:04:52 plynn54 auditd[1313]: Error sending signal_info request 
(Operation not supported)
Jul  6 20:04:52 plynn54 auditd[1313]: The audit daemon is exiting.
Jul  6 20:04:52 plynn54 kernel: audit(1246925092.486:387): audit_pid=0 
old=1313 auid=4294967295 ses=4294967295 res=1
Jul  6 20:04:52 plynn54 kernel: Kernel logging (proc) stopped.
Jul  6 20:05:29 plynn54 kernel: imklog 3.21.11, log source = /proc/kmsg 
started.
Jul  6 20:05:29 plynn54 kernel: Initializing cgroup subsys cpuset
Jul  6 20:05:29 plynn54 kernel: Initializing cgroup subsys cpu
Jul  6 20:05:29 plynn54 kernel: Linux version 2.6.29.5-191.fc11.x86_64 
(mockbuild@x86-5.fedora.phx.redhat.com) (gcc version 4.4.0 20090506 (Red 
Hat 4.4.0-4) (GCC) ) #1 SMP Tue Jun 16 23:23:21 EDT 2009
Jul  6 20:05:29 plynn54 kernel: Command line: ro 
root=/dev/VolGroup00/LogVol00 rhgb quiet
Jul  6 20:05:29 plynn54 kernel: KERNEL supported cpus:
Jul  6 20:05:29 plynn54 kernel:  Intel GenuineIntel
Jul  6 20:05:29 plynn54 kernel:  AMD AuthenticAMD
Jul  6 20:05:29 plynn54 kernel:  Centaur CentaurHauls
Jul  6 20:05:29 plynn54 kernel: BIOS-provided physical RAM map:
Jul  6 20:05:29 plynn54 kernel: BIOS-e820: 0000000000000000 - 
000000000008f000 (usable)
Jul  6 20:05:29 plynn54 kernel: BIOS-e820: 000000000008f000 - 
00000000000a0000 (reserved)




Dmesg:
[plynn54@plynn54 ~]$ 
dmesg                                                                         

Initializing cgroup subsys 
cpuset                                                                 
Initializing cgroup subsys 
cpu                                                                    
Linux version 2.6.29.5-191.fc11.x86_64 
(mockbuild@x86-5.fedora.phx.redhat.com) (gcc version 4.4.0 20090506 (Red 
Hat 4.4.0-4) (GCC) ) #1 SMP Tue Jun 16 23:23:21 EDT 
2009                                                         
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb 
quiet                                                       
KERNEL supported 
cpus:                                                                                           

  Intel 
GenuineIntel                                                                                             

  AMD 
AuthenticAMD                                                                                               

  Centaur 
CentaurHauls                                                                                           

BIOS-provided physical RAM 
map:                                                                                  

 BIOS-e820: 0000000000000000 - 000000000008f000 
(usable)                                                        
 BIOS-e820: 000000000008f000 - 00000000000a0000 
(reserved)                                                      
 BIOS-e820: 00000000000e0000 - 0000000000100000 
(reserved)                                                      
 BIOS-e820: 0000000000100000 - 00000000cf543000 
(usable)                                                        
 BIOS-e820: 00000000cf543000 - 00000000cf54f000 
(reserved)                                                      
 BIOS-e820: 00000000cf54f000 - 00000000cf5fe000 
(usable)                                                        
 BIOS-e820: 00000000cf5fe000 - 00000000cf6e8000 (ACPI 
NVS)                                                      
 BIOS-e820: 00000000cf6e8000 - 00000000cf6ec000 
(usable)                                                        
 BIOS-e820: 00000000cf6ec000 - 00000000cf6f1000 (ACPI 
data)                                                     
 BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 
(usable)                                                        
 BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI 
data)                                                     
 BIOS-e820: 00000000cf6ff000 - 00000000cf700000 
(usable)                                                        
 BIOS-e820: 00000000cf700000 - 00000000d0000000 
(reserved)                                                      
 BIOS-e820: 00000000fff00000 - 0000000100000000 
(reserved)                                                      
 BIOS-e820: 0000000100000000 - 0000000230000000 
(usable)                                                        
DMI 2.4 
present.                                                                                                 

last_pfn = 0x230000 max_arch_pfn = 
0x100000000                                                                   

x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106                                                
original variable 
MTRRs                                                                                          

reg 0, base: 0GB, range: 2GB, type 
WB                                                                            

reg 1, base: 2GB, range: 1GB, type 
WB                                                                            

reg 2, base: 3GB, range: 256MB, type 
WB                                                                         
reg 3, base: 3320MB, range: 8MB, type 
UC                                                                        
reg 4, base: 3319MB, range: 1MB, type 
UC                                                                        
reg 5, base: 4GB, range: 4GB, type 
WB                                                                            

reg 6, base: 8GB, range: 2GB, type 
WB                                                                            

total RAM coverred: 
9463M                                                                                        

Found optimal setting for mtrr clean 
up                                                                         
 gran_size: 64K         chunk_size: 16M         num_reg: 7      lose 
cover RAM: 0G                              
New variable 
MTRRs                                                                                               

reg 0, base: 0GB, range: 2GB, type 
WB                                                                            

reg 1, base: 2GB, range: 1GB, type 
WB                                                                            

reg 2, base: 3GB, range: 256MB, type 
WB                                                                         
reg 3, base: 3319MB, range: 1MB, type 
UC                                                                        
reg 4, base: 3320MB, range: 8MB, type 
UC                                                                        
reg 5, base: 4GB, range: 4GB, type 
WB                                                                            

reg 6, base: 8GB, range: 2GB, type 
WB                                                                            

x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106                                                
last_pfn = 0xcf700 max_arch_pfn = 
0x100000000                                                                    

init_memory_mapping: 
0000000000000000-00000000cf700000                                                           

 0000000000 - 00cf600000 page 
2M                                                                                 

 00cf600000 - 00cf700000 page 
4k                                                                                 

kernel direct mapping tables up to cf700000 @ 
8000-e000                                                         
last_map_addr: cf700000 end: 
cf700000                                                                            

init_memory_mapping: 
0000000100000000-0000000230000000                                                           

 0100000000 - 0230000000 page 
2M                                                                                 

kernel direct mapping tables up to 230000000 @ 
c000-16000                                                       
last_map_addr: 230000000 end: 
230000000                                                                          

RAMDISK: 37c6e000 - 
37fef9c0                                                                                     

ACPI: RSDP 000FE020, 0014 (r0 INTEL 
)                                                                            

ACPI: RSDT CF6FD038, 004C (r1 INTEL  ECG3510M       6A       
1000013)                                           
ACPI: FACP CF6FC000, 0074 (r1 INTEL  ECG3510M       6A MSFT  
1000013)                                           
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN 
(4)                                              
ACPI: DSDT CF6F6000, 5BEB (r1 INTEL  ECG3510M       6A MSFT  
1000013)                                           
ACPI: FACS CF693000, 
0040                                                                                        

ACPI: APIC CF6F5000, 0078 (r1 INTEL  ECG3510M       6A MSFT  
1000013)                                           
ACPI: WDDT CF6F4000, 0040 (r1 INTEL  ECG3510M       6A MSFT  
1000013)                                           
ACPI: MCFG CF6F3000, 003C (r1 INTEL  ECG3510M       6A MSFT  
1000013)                                           
ACPI: ASF! CF6F2000, 00A6 (r32 INTEL  ECG3510M       6A MSFT  
1000013)                                          
ACPI: SSDT CF6F0000, 020C (r1 INTEL     CpuPm       6A MSFT  
1000013)                                           
ACPI: SSDT CF6EF000, 01B7 (r1 INTEL   Cpu0Ist       6A MSFT  
1000013)                                           
ACPI: SSDT CF6EE000, 01B7 (r1 INTEL   Cpu1Ist       6A MSFT  
1000013)                                           
ACPI: SSDT CF6ED000, 01B7 (r1 INTEL   Cpu2Ist       6A MSFT  
1000013)                                           
ACPI: SSDT CF6EC000, 01B7 (r1 INTEL   Cpu3Ist       6A MSFT  
1000013)                                           
ACPI: Local APIC address 
0xfee00000                                                                              

No NUMA configuration 
found                                                                                      

Faking a node at 
0000000000000000-0000000230000000                                                               

Bootmem setup node 0 
0000000000000000-0000000230000000                                                           

  NODE_DATA [0000000000011000 - 
0000000000025fff]                                                                

  bootmap [0000000000026000 -  000000000006bfff] pages 
46                                                       
(7 early reservations) ==> bootmem [0000000000 - 
0230000000]                                                    
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 
0000001000]                                   
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 
0000008000]                                   
  #2 [0000200000 - 0000ac700c]    TEXT DATA BSS ==> [0000200000 - 
0000ac700c]                                   
  #3 [0037c6e000 - 0037fef9c0]          RAMDISK ==> [0037c6e000 - 
0037fef9c0]                                   
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 
0000100000]                                   
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 
000000c000]                                   
  #6 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 
0000011000]                                   
found SMP MP-table at [ffff8800000fe200] 
000fe200                                                               
 [ffffe20000000000-ffffe20007bfffff] PMD -> 
[ffff880028200000-ffff88002f3fffff] on node 0                       
Zone PFN 
ranges:                                                                                                 

  DMA      0x00000000 -> 
0x00001000                                                                              

  DMA32    0x00001000 -> 
0x00100000                                                                              

  Normal   0x00100000 -> 
0x00230000                                                                              

Movable zone start PFN for each 
node                                                                             

early_node_map[7] active PFN 
ranges                                                                              

    0: 0x00000000 -> 
0x0000008f                                                                                  

    0: 0x00000100 -> 
0x000cf543                                                                                  

    0: 0x000cf54f -> 
0x000cf5fe                                                                                  

    0: 0x000cf6e8 -> 
0x000cf6ec                                                                                  

    0: 0x000cf6f1 -> 
0x000cf6f2                                                                                  

    0: 0x000cf6ff -> 
0x000cf700                                                                                  

    0: 0x00100000 -> 
0x00230000                                                                                  

On node 0 totalpages: 
2094471                                                                                    

  DMA zone: 56 pages used for 
memmap                                                                             

  DMA zone: 2357 pages 
reserved                                                                                  

  DMA zone: 1570 pages, LIFO 
batch:0                                                                             

  DMA32 zone: 14280 pages used for 
memmap                                                                        

  DMA32 zone: 831024 pages, LIFO 
batch:31                                                                        

  Normal zone: 17024 pages used for 
memmap                                                                       

  Normal zone: 1228160 pages, LIFO 
batch:31                                                                      

ACPI: PM-Timer IO Port: 
0x408                                                                                    

ACPI: Local APIC address 
0xfee00000                                                                              

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] 
enabled)                                                              
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] 
enabled)                                                              
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] 
enabled)                                                              
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] 
enabled)                                                              
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl 
lint[0x1])                                                               
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl 
lint[0x1])                                                               
ACPI: IOAPIC (id[0x02] address[0xfec00000] 
gsi_base[0])                                                         
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 
0-23                                                   
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl 
dfl)                                                        
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high 
level)                                                     
ACPI: IRQ0 used by 
override.                                                                                     

ACPI: IRQ2 used by 
override.                                                                                     

ACPI: IRQ9 used by 
override.                                                                                     

Using ACPI (MADT) for SMP configuration 
information                                                             
SMP: Allowing 4 CPUs, 0 hotplug 
CPUs                                                                             

nr_irqs_gsi: 
24                                                                                                  

PM: Registered nosave memory: 000000000008f000 - 
00000000000a0000                                               
PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000                                               
PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000                                               
PM: Registered nosave memory: 00000000cf543000 - 
00000000cf54f000                                               
PM: Registered nosave memory: 00000000cf5fe000 - 
00000000cf6e8000                                               
PM: Registered nosave memory: 00000000cf6ec000 - 
00000000cf6f1000                                               
PM: Registered nosave memory: 00000000cf6f2000 - 
00000000cf6ff000                                               
PM: Registered nosave memory: 00000000cf700000 - 
00000000d0000000                                               
PM: Registered nosave memory: 00000000d0000000 - 
00000000fff00000                                               
PM: Registered nosave memory: 00000000fff00000 - 
0000000100000000                                               
Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ff00000)                                          
NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 
nr_node_ids:1                                                        
PERCPU: Allocating 57344 bytes of per cpu 
data                                                                  
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 
2060754                                    
Policy zone: 
Normal                                                                                              

Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb 
quiet                                                
Initializing 
CPU#0                                                                                               

PID hash table entries: 4096 (order: 12, 32768 
bytes)                                                           
Fast TSC calibration using 
PIT                                                                                   

Detected 2653.394 MHz 
processor.                                                                                 

Console: colour VGA+ 
80x25                                                                                       

console [tty0] 
enabled                                                                                           

allocated 83886080 bytes of 
page_cgroup                                                                          

please try cgroup_disable=memory option if you don't 
want                                                       
Checking 
aperture...                                                                                             

No AGP bridge 
found                                                                                              

Calgary: detecting Calgary via BIOS EBDA 
area                                                                   
Calgary: Unable to locate Rio Grande table in EBDA - 
bailing!                                                   
PCI-DMA: Using software bounce buffering for IO 
(SWIOTLB)                                                       
Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000                                        
software IO TLB at phys 0x20000000 - 
0x24000000                                                                 
Memory: 8099988k/9175040k available (3786k kernel code, 797156k absent, 
277896k reserved, 2293k data, 1304k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1                                         
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5306.78 BogoMIPS (lpj=2653394)       
Security Framework 
initialized                                                                                   

SELinux:  
Initializing.                                                                                          

SELinux:  Starting in permissive 
mode                                                                            

Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)                                             
Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)                                               
Mount-cache hash table entries: 
256                                                                              

Initializing cgroup subsys 
ns                                                                                    

Initializing cgroup subsys 
cpuacct                                                                               

Initializing cgroup subsys 
memory                                                                                

Initializing cgroup subsys 
devices                                                                               

Initializing cgroup subsys 
freezer                                                                               

Initializing cgroup subsys 
net_cls                                                                               

CPU: L1 I cache: 32K, L1 D cache: 
32K                                                                            

CPU: L2 cache: 
4096K                                                                                             

CPU 0/0x0 -> Node 
0                                                                                              

CPU: Physical Processor ID: 
0                                                                                    

CPU: Processor Core ID: 
0                                                                                        

CPU0: Thermal monitoring enabled 
(TM2)                                                                           

using mwait in idle 
threads.                                                                                     

ACPI: Core revision 
20081204                                                                                     

ftrace: converting mcount calls to 0f 1f 44 00 
00                                                               
ftrace: allocating 18886 entries in 149 
pages                                                                   
Setting APIC routing to 
flat                                                                                     

..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 
pin2=-1                                                            
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz stepping 
0b                                               
APIC calibration not consistent with PM Timer: 101ms instead of 
100ms                                           
APIC delta adjusted to PM-Timer: 1658328 
(1691240)                                                              
Booting processor 1 APIC 0x2 ip 
0x6000                                                                           

Initializing 
CPU#1                                                                                               

Calibrating delay using timer specific routine.. 5306.64 BogoMIPS 
(lpj=2653324)                                 
CPU: L1 I cache: 32K, L1 D cache: 
32K                                                                            

CPU: L2 cache: 
4096K                                                                                             

CPU 1/0x2 -> Node 
0                                                                                              

CPU: Physical Processor ID: 
0                                                                                    

CPU: Processor Core ID: 
2                                                                                        

CPU1: Thermal monitoring enabled 
(TM2)                                                                           

x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106                                                
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz stepping 
0b                                               
checking TSC synchronization [CPU#0 -> CPU#1]: 
passed.                                                          
Booting processor 2 APIC 0x1 ip 
0x6000                                                                           

Initializing 
CPU#2                                                                                               

Calibrating delay using timer specific routine.. 5306.62 BogoMIPS 
(lpj=2653311)                                 
CPU: L1 I cache: 32K, L1 D cache: 
32K                                                                            

CPU: L2 cache: 
4096K                                                                                             

CPU 2/0x1 -> Node 
0                                                                                              

CPU: Physical Processor ID: 
0                                                                                    

CPU: Processor Core ID: 
1                                                                                        

CPU2: Thermal monitoring enabled 
(TM2)                                                                           

x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106                                                
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz stepping 
0b                                               
checking TSC synchronization [CPU#0 -> CPU#2]: 
passed.                                                          
Booting processor 3 APIC 0x3 ip 
0x6000                                                                           

Initializing 
CPU#3                                                                                               

Calibrating delay using timer specific routine.. 5306.62 BogoMIPS 
(lpj=2653312)                                 
CPU: L1 I cache: 32K, L1 D cache: 
32K                                                                            

CPU: L2 cache: 
4096K                                                                                             

CPU 3/0x3 -> Node 
0                                                                                              

CPU: Physical Processor ID: 
0                                                                                    

CPU: Processor Core ID: 
3                                                                                        

CPU3: Thermal monitoring enabled 
(TM2)                                                                           

x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106                                                
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz stepping 
0b                                               
checking TSC synchronization [CPU#0 -> CPU#3]: 
passed.                                                          
Brought up 4 
CPUs                                                                                                

Total of 4 processors activated (21226.68 
BogoMIPS).                                                            
sizeof(vma)=176 
bytes                                                                                            

sizeof(page)=56 
bytes                                                                                            

sizeof(inode)=560 
bytes                                                                                          

sizeof(dentry)=192 
bytes                                                                                         

sizeof(ext3inode)=760 
bytes                                                                                      

sizeof(buffer_head)=104 
bytes                                                                                    

sizeof(skbuff)=232 
bytes                                                                                         

sizeof(task_struct)=5880 
bytes                                                                                   

CPU0 attaching 
sched-domain:                                                                                     

 domain 0: span 0,2 level 
MC                                                                                     

  groups: 0 
2                                                                                                    

  domain 1: span 0-3 level 
CPU                                                                                   

   groups: 0,2 
1,3                                                                                               

CPU1 attaching 
sched-domain:                                                                                     

 domain 0: span 1,3 level 
MC                                                                                     

  groups: 1 
3                                                                                                    

  domain 1: span 0-3 level 
CPU                                                                                   

   groups: 1,3 
0,2                                                                                               

CPU2 attaching 
sched-domain:                                                                                     

 domain 0: span 0,2 level 
MC                                                                                     

  groups: 2 
0                                                                                                    

  domain 1: span 0-3 level 
CPU                                                                                   

   groups: 0,2 
1,3                                                                                               

CPU3 attaching 
sched-domain:                                                                                     

 domain 0: span 1,3 level 
MC                                                                                     

  groups: 3 
1                                                                                                    

  domain 1: span 0-3 level 
CPU                                                                                   

   groups: 1,3 
0,2                                                                                               

net_namespace: 1904 
bytes                                                                                        

Booting paravirtualized kernel on bare 
hardware                                                                 
regulator: core version 
0.5                                                                                      

Time:  0:05:13  Date: 
07/07/09                                                                                   

NET: Registered protocol family 
16                                                                               

ACPI: bus type pci 
registered                                                                                    

PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 
127                                                
PCI: Not using 
MMCONFIG.                                                                                         

PCI: Using configuration type 1 for base 
access                                                                 
bio: create slab <bio-0> at 
0                                                                                    

ACPI: EC: Look up EC in 
DSDT                                                                                     

ACPI: Interpreter 
enabled                                                                                        

ACPI: (supports S0 S1 S3 S4 
S5)                                                                                  

ACPI: Using IOAPIC for interrupt 
routing                                                                         

PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 
127                                                
PCI: MCFG area at f0000000 reserved in ACPI motherboard 
resources                                               
PCI: Using MMCONFIG at f0000000 - 
f7ffffff                                                                       

ACPI: No dock devices 
found.                                                                                     

ACPI: PCI Root Bridge [PCI0] 
(0000:00)                                                                           

pci 0000:00:02.0: reg 10 32bit mmio: 
[0xe0200000-0xe02fffff]                                                    
pci 0000:00:02.0: reg 18 64bit mmio: 
[0xd0000000-0xdfffffff]                                                    
pci 0000:00:02.0: reg 20 io port: 
[0x3440-0x3447]                                                                

pci 0000:00:02.1: reg 10 32bit mmio: 
[0xe0100000-0xe01fffff]                                                    
pci 0000:00:19.0: reg 10 32bit mmio: 
[0xe0300000-0xe031ffff]                                                    
pci 0000:00:19.0: reg 14 32bit mmio: 
[0xe0324000-0xe0324fff]                                                    
pci 0000:00:19.0: reg 18 io port: 
[0x30c0-0x30df]                                                                

pci 0000:00:19.0: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:19.0: PME# 
disabled                                                                                  

pci 0000:00:1a.0: reg 20 io port: 
[0x30a0-0x30bf]                                                                

pci 0000:00:1a.1: reg 20 io port: 
[0x3080-0x309f]                                                                

pci 0000:00:1a.7: reg 10 32bit mmio: 
[0xe0325400-0xe03257ff]                                                    
pci 0000:00:1a.7: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1a.7: PME# 
disabled                                                                                  

pci 0000:00:1b.0: reg 10 64bit mmio: 
[0xe0320000-0xe0323fff]                                                    
pci 0000:00:1b.0: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1b.0: PME# 
disabled                                                                                  

pci 0000:00:1c.0: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1c.0: PME# 
disabled                                                                                  

pci 0000:00:1c.1: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1c.1: PME# 
disabled                                                                                  

pci 0000:00:1c.2: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1c.2: PME# 
disabled                                                                                  

pci 0000:00:1d.0: reg 20 io port: 
[0x3060-0x307f]                                                                

pci 0000:00:1d.1: reg 20 io port: 
[0x3040-0x305f]                                                                

pci 0000:00:1d.2: reg 20 io port: 
[0x3020-0x303f]                                                                

pci 0000:00:1d.7: reg 10 32bit mmio: 
[0xe0325000-0xe03253ff]                                                    
pci 0000:00:1d.7: PME# supported from D0 D3hot 
D3cold                                                           
pci 0000:00:1d.7: PME# 
disabled                                                                                  

pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO                                         
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 
GPIO                                                  
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 
007f)                                          
pci 0000:00:1f.2: reg 10 io port: 
[0x3438-0x343f]                                                                

pci 0000:00:1f.2: reg 14 io port: 
[0x3454-0x3457]                                                                

pci 0000:00:1f.2: reg 18 io port: 
[0x3430-0x3437]                                                                

pci 0000:00:1f.2: reg 1c io port: 
[0x3450-0x3453]                                                                

pci 0000:00:1f.2: reg 20 io port: 
[0x3410-0x341f]                                                                

pci 0000:00:1f.2: reg 24 io port: 
[0x3400-0x340f]                                                                

pci 0000:00:1f.2: PME# supported from 
D3hot                                                                     
pci 0000:00:1f.2: PME# 
disabled                                                                                  

pci 0000:00:1f.3: reg 10 32bit mmio: 
[0xe0325800-0xe03258ff]                                                    
pci 0000:00:1f.3: reg 20 io port: 
[0x3000-0x301f]                                                                

pci 0000:00:1f.5: reg 10 io port: 
[0x3428-0x342f]                                                                

pci 0000:00:1f.5: reg 14 io port: 
[0x344c-0x344f]                                                                

pci 0000:00:1f.5: reg 18 io port: 
[0x3420-0x3427]                                                                

pci 0000:00:1f.5: reg 1c io port: 
[0x3448-0x344b]                                                                

pci 0000:00:1f.5: reg 20 io port: 
[0x30f0-0x30ff]                                                                

pci 0000:00:1f.5: reg 24 io port: 
[0x30e0-0x30ef]                                                                

pci 0000:00:1f.5: PME# supported from 
D3hot                                                                     
pci 0000:00:1f.5: PME# 
disabled                                                                                  

pci 0000:03:00.0: reg 10 io port: 
[0x2018-0x201f]                                                                

pci 0000:03:00.0: reg 14 io port: 
[0x2024-0x2027]                                                                

pci 0000:03:00.0: reg 18 io port: 
[0x2010-0x2017]                                                                

pci 0000:03:00.0: reg 1c io port: 
[0x2020-0x2023]                                                                

pci 0000:03:00.0: reg 20 io port: 
[0x2000-0x200f]                                                                

pci 0000:03:00.0: reg 30 32bit mmio: 
[0xffff0000-0xffffffff]                                                    
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable 
it with 'pcie_aspm=force'              
pci 0000:00:1c.2: bridge io port: 
[0x2000-0x2fff]                                                                

pci 0000:04:03.0: reg 10 32bit mmio: 
[0xe0021000-0xe0021fff]                                                    
pci 0000:04:03.0: reg 14 io port: 
[0x1000-0x103f]                                                                

pci 0000:04:03.0: reg 18 32bit mmio: 
[0xe0000000-0xe001ffff]                                                    
pci 0000:04:03.0: reg 30 32bit mmio: 
[0xffff0000-0xffffffff]                                                    
pci 0000:04:03.0: supports D1 
D2                                                                                 

pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot 
D3cold                                                     
pci 0000:04:03.0: PME# 
disabled                                                                                  

pci 0000:04:05.0: reg 10 32bit mmio: 
[0xe0020000-0xe0020fff]                                                    
pci 0000:04:05.0: supports D1 
D2                                                                                 

pci 0000:04:05.0: PME# supported from D0 D1 D2 
D3hot                                                            
pci 0000:04:05.0: PME# 
disabled                                                                                  

pci 0000:00:1e.0: transparent 
bridge                                                                             

pci 0000:00:1e.0: bridge io port: 
[0x1000-0x1fff]                                                                

pci 0000:00:1e.0: bridge 32bit mmio: 
[0xe0000000-0xe00fffff]                                                    
ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0._PRT]                                                              

ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.P32_._PRT]                                                         

ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX0._PRT]                                                         

ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX1._PRT]                                                         

ACPI: PCI Interrupt Routing Table 
[\_SB_.PCI0.PEX2._PRT]                                                         

ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 
12)                                                      
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 
12)                                                      
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 
12)                                                      
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 
12)                                                      
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 
12)                                                      
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 
12)                                                      
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 
12)                                                      
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 
12)                                                      
SCSI subsystem 
initialized                                                                                       

libata version 3.00 
loaded.                                                                                      

usbcore: registered new interface driver 
usbfs                                                                  
usbcore: registered new interface driver 
hub                                                                    
usbcore: registered new device driver 
usb                                                                       
PCI: Using ACPI for IRQ 
routing                                                                                  

NetLabel: 
Initializing                                                                                           

NetLabel:  domain hash size = 
128                                                                                

NetLabel:  protocols = UNLABELED 
CIPSOv4                                                                         

NetLabel:  unlabeled traffic allowed by 
default                                                                 
pnp: PnP ACPI 
init                                                                                               

ACPI: bus type pnp 
registered                                                                                    

pnp: PnP ACPI: found 10 
devices                                                                                  

ACPI: ACPI bus type pnp 
unregistered                                                                             

system 00:01: iomem range 0xf0000000-0xf7ffffff has been 
reserved                                               
system 00:01: iomem range 0xfed13000-0xfed13fff has been 
reserved                                               
system 00:01: iomem range 0xfed14000-0xfed17fff has been 
reserved                                               
system 00:01: iomem range 0xfed18000-0xfed18fff has been 
reserved                                               
system 00:01: iomem range 0xfed19000-0xfed19fff has been 
reserved                                               
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been 
reserved                                               
system 00:01: iomem range 0xfed20000-0xfed3ffff has been 
reserved                                               
system 00:01: iomem range 0xfed45000-0xfed99fff has been 
reserved                                               
system 00:01: iomem range 0xc0000-0xdffff has been 
reserved                                                     
system 00:01: iomem range 0xe0000-0xfffff could not be 
reserved                                                 
system 00:06: ioport range 0x500-0x53f has been 
reserved                                                        
system 00:06: ioport range 0x400-0x47f has been 
reserved                                                        
system 00:06: ioport range 0x360-0x361 has been 
reserved                                                        
system 00:06: ioport range 0x680-0x6ff has been 
reserved                                                        
pci 0000:00:1c.0: PCI bridge, secondary bus 
0000:01                                                             
pci 0000:00:1c.0:   IO window: 
disabled                                                                          

pci 0000:00:1c.0:   MEM window: 
disabled                                                                         

pci 0000:00:1c.0:   PREFETCH window: 
disabled                                                                   
pci 0000:00:1c.1: PCI bridge, secondary bus 
0000:02                                                             
pci 0000:00:1c.1:   IO window: 
disabled                                                                          

pci 0000:00:1c.1:   MEM window: 
disabled                                                                         

pci 0000:00:1c.1:   PREFETCH window: 
disabled                                                                   
pci 0000:00:1c.2: PCI bridge, secondary bus 
0000:03                                                             
pci 0000:00:1c.2:   IO window: 
0x2000-0x2fff                                                                     

pci 0000:00:1c.2:   MEM window: 
disabled                                                                         

pci 0000:00:1c.2:   PREFETCH window: 
0x000000e0400000-0x000000e04fffff                                          
pci 0000:00:1e.0: PCI bridge, secondary bus 
0000:04                                                             
pci 0000:00:1e.0:   IO window: 
0x1000-0x1fff                                                                     

pci 0000:00:1e.0:   MEM window: 
0xe0000000-0xe00fffff                                                            

pci 0000:00:1e.0:   PREFETCH window: 
0x000000e0500000-0x000000e05fffff                                          
  alloc irq_desc for 17 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17                                                    
pci 0000:00:1c.0: setting latency timer to 
64                                                                   
  alloc irq_desc for 16 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 
16                                                    
pci 0000:00:1c.1: setting latency timer to 
64                                                                   
  alloc irq_desc for 18 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18                                                    
pci 0000:00:1c.2: setting latency timer to 
64                                                                   
pci 0000:00:1e.0: setting latency timer to 
64                                                                   
pci_bus 0000:00: resource 0 io:  
[0x00-0xffff]                                                                   

pci_bus 0000:00: resource 1 mem: 
[0x000000-0xffffffffffffffff]                                                   

pci_bus 0000:01: resource 0 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:01: resource 1 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:01: resource 2 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:01: resource 3 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:02: resource 0 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:02: resource 1 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:02: resource 2 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:02: resource 3 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:03: resource 0 io:  
[0x2000-0x2fff]                                                                 

pci_bus 0000:03: resource 1 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:03: resource 2 mem: 
[0xe0400000-0xe04fffff]                                                         

pci_bus 0000:03: resource 3 mem: 
[0x0-0x0]                                                                       

pci_bus 0000:04: resource 0 io:  
[0x1000-0x1fff]                                                                 

pci_bus 0000:04: resource 1 mem: 
[0xe0000000-0xe00fffff]                                                         

pci_bus 0000:04: resource 2 mem: 
[0xe0500000-0xe05fffff]                                                         

pci_bus 0000:04: resource 3 io:  
[0x00-0xffff]                                                                   

pci_bus 0000:04: resource 4 mem: 
[0x000000-0xffffffffffffffff]                                                   

NET: Registered protocol family 
2                                                                                

IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)                                             
TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)                                           
TCP bind hash table entries: 65536 (order: 8, 1048576 
bytes)                                                    
TCP: Hash tables configured (established 524288 bind 
65536)                                                     
TCP reno 
registered                                                                                              

NET: Registered protocol family 
1                                                                                

checking if image is initramfs... it 
is                                                                         
Freeing initrd memory: 3590k 
freed                                                                               

audit: initializing netlink socket 
(disabled)                                                                    

type=2000 audit(1246925112.503:1): 
initialized                                                                   

HugeTLB registered 2 MB page size, pre-allocated 0 
pages                                                        
VFS: Disk quotas 
dquot_6.5.2                                                                                     

Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)                                                       
msgmni has been set to 
15827                                                                                     

SELinux:  Registering netfilter 
hooks                                                                            

alg: No test for stdrng 
(krng)                                                                                   

Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
252)                                            
io scheduler noop 
registered                                                                                     

io scheduler anticipatory 
registered                                                                             

io scheduler deadline 
registered                                                                                 

io scheduler cfq registered 
(default)                                                                            

pci 0000:00:02.0: Boot video 
device                                                                              

pci 0000:04:03.0: Firmware left e100 interrupts enabled; 
disabling                                              
pcieport-driver 0000:00:1c.0: setting latency timer to 
64                                                       
  alloc irq_desc for 24 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pcieport-driver 0000:00:1c.0: irq 24 for 
MSI/MSI-X                                                              
pcieport-driver 0000:00:1c.1: setting latency timer to 
64                                                       
  alloc irq_desc for 25 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pcieport-driver 0000:00:1c.1: irq 25 for 
MSI/MSI-X                                                              
pcieport-driver 0000:00:1c.2: setting latency timer to 
64                                                       
  alloc irq_desc for 26 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

pcieport-driver 0000:00:1c.2: irq 26 for 
MSI/MSI-X                                                              
pci_hotplug: PCI Hot Plug PCI Core version: 
0.5                                                                 
pciehp: PCI Express Hot Plug Controller Driver version: 
0.4                                                     
acpiphp: ACPI Hot Plug PCI Controller Driver version: 
0.5                                                       
acpiphp_glue: can't get bus number, assuming 
0                                                                  
input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0                                        

ACPI: Power Button (FF) 
[PWRF]                                                                                   

input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1                               

ACPI: Sleep Button (CM) 
[SLPB]                                                                                   

processor ACPI_CPU:00: registered as 
cooling_device0                                                            
ACPI: Processor [CPU0] (supports 8 throttling 
states)                                                           
processor ACPI_CPU:01: registered as 
cooling_device1                                                            
ACPI: Processor [CPU1] (supports 8 throttling 
states)                                                           
processor ACPI_CPU:02: registered as 
cooling_device2                                                            
ACPI: Processor [CPU2] (supports 8 throttling 
states)                                                           
processor ACPI_CPU:03: registered as 
cooling_device3                                                            
ACPI: Processor [CPU3] (supports 8 throttling 
states)                                                           
Non-volatile memory driver 
v1.3                                                                                  

Linux agpgart interface 
v0.103                                                                                   

agpgart-intel 0000:00:00.0: Intel G35 
Chipset                                                                   
agpgart-intel 0000:00:00.0: detected 7676K stolen 
memory                                                        
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 
0xd0000000                                                   
Serial: 8250/16550 driver, 4 ports, IRQ sharing 
enabled                                                         
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 
16550A                                                            
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 
16550A                                                                 
brd: module 
loaded                                                                                               

loop: module 
loaded                                                                                              

Fixed MDIO Bus: 
probed                                                                                           

input: Macintosh mouse button emulation as 
/devices/virtual/input/input2                                        
Driver 'sd' needs updating - please use bus_type 
methods                                                        
Driver 'sr' needs updating - please use bus_type 
methods                                                        
ata_piix 0000:00:1f.2: version 
2.12                                                                              

  alloc irq_desc for 19 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

ata_piix 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 
19                                               
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 
]                                                                      
Switched to high resolution mode on CPU 
1                                                                       
Switched to high resolution mode on CPU 
3                                                                       
Switched to high resolution mode on CPU 
2                                                                       
Switched to high resolution mode on CPU 
0                                                                       
ata_piix 0000:00:1f.2: setting latency timer to 
64                                                              
scsi0 : 
ata_piix                                                                                                 

scsi1 : 
ata_piix                                                                                                 

ata1: SATA max UDMA/133 cmd 0x3438 ctl 0x3454 bmdma 0x3410 irq 
19                                               
ata2: SATA max UDMA/133 cmd 0x3430 ctl 0x3450 bmdma 0x3418 irq 
19                                               
ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 
300)                                                       
ata1.01: SATA link down (SStatus 4 SControl 
300)                                                                
ata1.00: ATA-8: WDC WD5000AAKS-22A7B2, 01.03B01, max 
UDMA/133                                                   
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 
0/32)                                                    
ata1.00: configured for 
UDMA/133                                                                                 

scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-2 01.0 PQ: 0 
ANSI: 5                                    
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 
GiB)                                         
sd 0:0:0:0: [sda] Write Protect is 
off                                                                           

sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 
00                                                                       
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA                         
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 
GiB)                                         
sd 0:0:0:0: [sda] Write Protect is 
off                                                                           

sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 
00                                                                       
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA                         
 sda: sda1 
sda2                                                                                                  

sd 0:0:0:0: [sda] Attached SCSI 
disk                                                                             

sd 0:0:0:0: Attached scsi generic sg0 type 
0                                                                    
ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)                                                       
ata2.01: SATA link down (SStatus 4 SControl 
300)                                                                
ata2.00: ATAPI: SONY    DVD RW DRU-V200S, 1.60, max 
UDMA/100                                                    
ata2.00: configured for 
UDMA/100                                                                                 

scsi 1:0:0:0: CD-ROM            SONY     DVD RW DRU-V200S 1.60 PQ: 0 
ANSI: 5                                    
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda 
tray                                           
Uniform CD-ROM driver Revision: 
3.20                                                                             

sr 1:0:0:0: Attached scsi CD-ROM 
sr0                                                                             

sr 1:0:0:0: Attached scsi generic sg1 type 
5                                                                    
ata_piix 0000:00:1f.5: PCI INT A -> GSI 19 (level, low) -> IRQ 
19                                               
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- 
]                                                                      
ata_piix 0000:00:1f.5: setting latency timer to 
64                                                              
scsi2 : 
ata_piix                                                                                                 

scsi3 : 
ata_piix                                                                                                 

ata3: SATA max UDMA/133 cmd 0x3428 ctl 0x344c bmdma 0x30f0 irq 
19                                               
ata4: SATA max UDMA/133 cmd 0x3420 ctl 0x3448 bmdma 0x30f8 irq 
19                                               
ata3: SATA link down (SStatus 0 SControl 
300)                                                                   
ata4: SATA link down (SStatus 0 SControl 
300)                                                                   
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) 
Driver                                                      
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18                                               
ehci_hcd 0000:00:1a.7: setting latency timer to 
64                                                              
ehci_hcd 0000:00:1a.7: EHCI Host 
Controller                                                                      

ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 
1                                            
ehci_hcd 0000:00:1a.7: debug port 
1                                                                              

ehci_hcd 0000:00:1a.7: cache line size of 32 is not 
supported                                                   
ehci_hcd 0000:00:1a.7: irq 18, io mem 
0xe0325400                                                                
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 
1.00                                                               
usb usb1: New USB device found, idVendor=1d6b, 
idProduct=0002                                                   
usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb1: Product: EHCI Host 
Controller                                                                          

usb usb1: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
ehci_hcd                                                 
usb usb1: SerialNumber: 
0000:00:1a.7                                                                             

usb usb1: configuration #1 chosen from 1 
choice                                                                 
hub 1-0:1.0: USB hub 
found                                                                                       

hub 1-0:1.0: 4 ports 
detected                                                                                    

  alloc irq_desc for 23 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23                                               
ehci_hcd 0000:00:1d.7: setting latency timer to 
64                                                              
ehci_hcd 0000:00:1d.7: EHCI Host 
Controller                                                                      

ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 
2                                            
ehci_hcd 0000:00:1d.7: debug port 
1                                                                              

ehci_hcd 0000:00:1d.7: cache line size of 32 is not 
supported                                                   
ehci_hcd 0000:00:1d.7: irq 23, io mem 
0xe0325000                                                                
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 
1.00                                                               
usb usb2: New USB device found, idVendor=1d6b, 
idProduct=0002                                                   
usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb2: Product: EHCI Host 
Controller                                                                          

usb usb2: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
ehci_hcd                                                 
usb usb2: SerialNumber: 
0000:00:1d.7                                                                             

usb usb2: configuration #1 chosen from 1 
choice                                                                 
hub 2-0:1.0: USB hub 
found                                                                                       

hub 2-0:1.0: 6 ports 
detected                                                                                    

ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) 
Driver                                                          
uhci_hcd: USB Universal Host Controller Interface 
driver                                                        
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16                                               
uhci_hcd 0000:00:1a.0: setting latency timer to 
64                                                              
uhci_hcd 0000:00:1a.0: UHCI Host 
Controller                                                                      

uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 
3                                            
uhci_hcd 0000:00:1a.0: irq 16, io base 
0x000030a0                                                               
usb usb3: New USB device found, idVendor=1d6b, 
idProduct=0001                                                   
usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb3: Product: UHCI Host 
Controller                                                                          

usb usb3: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
uhci_hcd                                                 
usb usb3: SerialNumber: 
0000:00:1a.0                                                                             

usb usb3: configuration #1 chosen from 1 
choice                                                                 
hub 3-0:1.0: USB hub 
found                                                                                       

hub 3-0:1.0: 2 ports 
detected                                                                                    

  alloc irq_desc for 21 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21                                               
uhci_hcd 0000:00:1a.1: setting latency timer to 
64                                                              
uhci_hcd 0000:00:1a.1: UHCI Host 
Controller                                                                      

uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 
4                                            
uhci_hcd 0000:00:1a.1: irq 21, io base 
0x00003080                                                               
usb usb4: New USB device found, idVendor=1d6b, 
idProduct=0001                                                   
usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb4: Product: UHCI Host 
Controller                                                                          

usb usb4: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
uhci_hcd                                                 
usb usb4: SerialNumber: 
0000:00:1a.1                                                                             

usb usb4: configuration #1 chosen from 1 
choice                                                                 
hub 4-0:1.0: USB hub 
found                                                                                       

hub 4-0:1.0: 2 ports 
detected                                                                                    

uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23                                               
uhci_hcd 0000:00:1d.0: setting latency timer to 
64                                                              
uhci_hcd 0000:00:1d.0: UHCI Host 
Controller                                                                      

uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 
5                                            
uhci_hcd 0000:00:1d.0: irq 23, io base 
0x00003060                                                               
usb usb5: New USB device found, idVendor=1d6b, 
idProduct=0001                                                   
usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb5: Product: UHCI Host 
Controller                                                                          

usb usb5: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
uhci_hcd                                                 
usb usb5: SerialNumber: 
0000:00:1d.0                                                                             

usb usb5: configuration #1 chosen from 1 
choice                                                                 
hub 5-0:1.0: USB hub 
found                                                                                       

hub 5-0:1.0: 2 ports 
detected                                                                                    

uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19                                               
uhci_hcd 0000:00:1d.1: setting latency timer to 
64                                                              
uhci_hcd 0000:00:1d.1: UHCI Host 
Controller                                                                      

uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 
6                                            
uhci_hcd 0000:00:1d.1: irq 19, io base 
0x00003040                                                               
usb usb6: New USB device found, idVendor=1d6b, 
idProduct=0001                                                   
usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb6: Product: UHCI Host 
Controller                                                                          

usb usb6: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
uhci_hcd                                                 
usb usb6: SerialNumber: 
0000:00:1d.1                                                                             

usb usb6: configuration #1 chosen from 1 
choice                                                                 
hub 6-0:1.0: USB hub 
found                                                                                       

hub 6-0:1.0: 2 ports 
detected                                                                                    

uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18                                               
uhci_hcd 0000:00:1d.2: setting latency timer to 
64                                                              
uhci_hcd 0000:00:1d.2: UHCI Host 
Controller                                                                      

uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 
7                                            
uhci_hcd 0000:00:1d.2: irq 18, io base 
0x00003020                                                               
usb usb7: New USB device found, idVendor=1d6b, 
idProduct=0001                                                   
usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                              
usb usb7: Product: UHCI Host 
Controller                                                                          

usb usb7: Manufacturer: Linux 2.6.29.5-191.fc11.x86_64 
uhci_hcd                                                 
usb usb7: SerialNumber: 
0000:00:1d.2                                                                             

usb usb7: configuration #1 chosen from 1 
choice                                                                 
hub 7-0:1.0: USB hub 
found                                                                                       

hub 7-0:1.0: 2 ports 
detected                                                                                    

PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 
1                                                          
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please 
boot with i8042.nopnp                  
serio: i8042 KBD port at 0x60,0x64 irq 
1                                                                        
mice: PS/2 mouse device common for all 
mice                                                                     
rtc_cmos 00:03: RTC can wake from 
S4                                                                             

rtc_cmos 00:03: rtc core: registered rtc_cmos as 
rtc0                                                           
rtc0: alarms up to one month, 114 bytes 
nvram                                                                   
device-mapper: uevent: version 
1.0.3                                                                             

device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com                                
cpuidle: using governor 
ladder                                                                                   

cpuidle: using governor 
menu                                                                                     

usbcore: registered new interface driver 
hiddev                                                                 
usbcore: registered new interface driver 
usbhid                                                                 
usbhid: v2.6:USB HID core 
driver                                                                                 

nf_conntrack version 0.5.0 (16384 buckets, 65536 
max)                                                           
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please 
use                                            
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option 
or                                      
sysctl net.netfilter.nf_conntrack_acct=1 to enable 
it.                                                          
ip_tables: (C) 2000-2006 Netfilter Core 
Team                                                                    
TCP cubic 
registered                                                                                             

Initializing XFRM netlink 
socket                                                                                 

NET: Registered protocol family 
17                                                                               

registered taskstats version 
1                                                                                   

  Magic number: 
1:41:51                                                                                          

Initalizing network drop monitor 
service                                                                         

Freeing unused kernel memory: 1304k 
freed                                                                        

Write protecting the kernel read-only data: 
1844k                                                               
input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input3                              
[drm] Initialized drm 1.1.0 
20060810                                                                             

i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16                                                   
i915 0000:00:02.0: setting latency timer to 
64                                                                  
  alloc irq_desc for 27 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

i915 0000:00:02.0: irq 27 for 
MSI/MSI-X                                                                          

usb 6-1: new low speed USB device using uhci_hcd and address 
2                                                  
usb 6-1: New USB device found, idVendor=046d, 
idProduct=c404                                                    
usb 6-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0                                               
usb 6-1: Product: 
Trackball                                                                                      

usb 6-1: Manufacturer: 
Logitech                                                                                  

usb 6-1: configuration #1 chosen from 1 
choice                                                                  
allocated 1440x900 fb: 0x007df000, bo 
ffff88022cac80c0                                                          
Console: switching to colour frame buffer device 
180x56                                                         
input: Logitech Trackball as 
/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input4                      

[drm] DAC-6: set mode 1440x900 
20                                                                                

fb0: inteldrmfb frame buffer 
device                                                                              

registered panic 
notifier                                                                                        

[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0                                               
generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse 
[Logitech Trackball] on 
usb-0000:00:1d.1-1/input0                                                                                                             

pata_acpi 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18                                              
pata_acpi 0000:03:00.0: setting latency timer to 
64                                                             
pata_acpi 0000:03:00.0: PCI INT A 
disabled                                                                       

EXT3-fs: INFO: recovery required on readonly 
filesystem.                                                        
EXT3-fs: write access will be enabled during 
recovery.                                                          
kjournald starting.  Commit interval 5 
seconds                                                                  
EXT3-fs: dm-0: orphan cleanup on readonly 
fs                                                                    
ext3_orphan_cleanup: deleting unreferenced inode 
14131833                                                       
ext3_orphan_cleanup: deleting unreferenced inode 
14131239                                                       
ext3_orphan_cleanup: deleting unreferenced inode 
14131221                                                       
ext3_orphan_cleanup: deleting unreferenced inode 
14131219                                                       
EXT3-fs: dm-0: 4 orphan inodes 
deleted                                                                           

EXT3-fs: recovery 
complete.                                                                                      

EXT3-fs: mounted filesystem with ordered data 
mode.                                                             
SELinux:  Disabled at 
runtime.                                                                                   

SELinux:  Unregistering netfilter 
hooks                                                                          

type=1404 audit(1246925120.432:2): selinux=0 auid=4294967295 
ses=4294967295                                     
udev: starting version 
141                                                                                       

input: PC Speaker as 
/devices/platform/pcspkr/input/input5                                                       

e100: Intel(R) PRO/100 Network Driver, 
3.5.23-k6-NAPI                                                           
e100: Copyright(c) 1999-2006 Intel 
Corporation                                                                   

e100 0000:04:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17                                                   
e100 0000:04:03.0: PME# 
disabled                                                                                 

iTCO_vendor_support: 
vendor-support=0                                                                            

e100: eth0: e100_probe: addr 0xe0021000, irq 17, MAC addr 
00:02:b3:36:b8:64                                     
udev: renamed network interface eth0 to 
eth1                                                                    
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 21 (level, low) -> IRQ 
21                                             
iTCO_wdt: Intel TCO WatchDog Timer Driver 
v1.05                                                                 
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, 
TCOBASE=0x0460)                                          
iTCO_wdt: initialized. heartbeat=30 sec 
(nowayout=0)                                                            
e1000e: Intel(R) PRO/1000 Network Driver - 
0.3.3.3-k6                                                           
e1000e: Copyright (c) 1999-2008 Intel 
Corporation.                                                              
  alloc irq_desc for 20 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20                                                 
e1000e 0000:00:19.0: setting latency timer to 
64                                                                
  alloc irq_desc for 28 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

e1000e 0000:00:19.0: irq 28 for 
MSI/MSI-X                                                                        

0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 
00:1c:c0:af:b3:98                                            
0000:00:19.0: eth0: Intel(R) PRO/1000 Network 
Connection                                                        
0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: 
ffffff-0ff                                                          
  alloc irq_desc for 22 on cpu 0 node 
0                                                                         
  alloc kstat_irqs on cpu 0 node 
0                                                                               

HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22                                              
HDA Intel 0000:00:1b.0: setting latency timer to 
64                                                             
hda_codec: Unknown model for ALC883, trying auto-probe from 
BIOS...                                             
ALSA sound/pci/hda/hda_codec.c:3507: autoconfig: line_outs=1 
(0x14/0x0/0x0/0x0/0x0)                             
ALSA sound/pci/hda/hda_codec.c:3511:    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)                                    
ALSA sound/pci/hda/hda_codec.c:3515:    hp_outs=1 
(0x1b/0x0/0x0/0x0/0x0)                                        
ALSA sound/pci/hda/hda_codec.c:3516:    mono: 
mono_out=0x0                                                      
ALSA sound/pci/hda/hda_codec.c:3524:    inputs: mic=0x18, fmic=0x19, 
line=0x1a, fline=0x0, cd=0x0, aux=0x0      
pata_jmicron 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18                                           
pata_jmicron 0000:03:00.0: setting latency timer to 
64                                                          
scsi4 : 
pata_jmicron                                                                                             

scsi5 : 
pata_jmicron                                                                                             

ata5: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 
18                                               
ata6: PATA max UDMA/100 cmd 0x2010 ctl 0x2020 bmdma 0x2008 irq 
18                                               
firewire_ohci 0000:04:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 
20                                          
firewire_ohci: Added fw-ohci device 0000:04:05.0, OHCI version 
1.0                                              
device-mapper: multipath: version 1.0.5 
loaded                                                                  
firewire_core: created device fw0: GUID 00902700024952e9, 
S400                                                  
EXT3 FS on dm-0, internal 
journal                                                                                

kjournald starting.  Commit interval 5 
seconds                                                                  
EXT3 FS on sda1, internal 
journal                                                                                

EXT3-fs: mounted filesystem with ordered data 
mode.                                                             
swap_cgroup: uses 39936 bytes of vmalloc for pointer array space and 
20447232 bytes to hold mem_cgroup pointers on 
swap                                                                                                           

swap_cgroup can be disabled by noswapaccount boot 
option.                                                       
Adding 10223608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 
extents:1 across:10223608k               
platform microcode: firmware: requesting 
intel-ucode/06-0f-0b                                                   
platform microcode: firmware: requesting 
intel-ucode/06-0f-0b                                                   
platform microcode: firmware: requesting 
intel-ucode/06-0f-0b                                                   
platform microcode: firmware: requesting 
intel-ucode/06-0f-0b                                                   
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter 
Oruba                                       
microcode: CPU0 updated from revision 0x0 to 0xb6, date = 
2007-07-13                                            
microcode: CPU1 updated from revision 0x0 to 0xb6, date = 
2007-07-13                                            
microcode: CPU2 updated from revision 0x0 to 0xb6, date = 
2007-07-13                                            
microcode: CPU3 updated from revision 0x0 to 0xb6, date = 2007-07-13
Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
w83627ehf: Found W83627DHG chip at 0x6e0
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
coretemp coretemp.2: Using relative temperature scale!
coretemp coretemp.3: Using relative temperature scale!
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
ADDRCONF(NETDEV_UP): eth1: link is not ready
e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
fuse init (API version 7.11)



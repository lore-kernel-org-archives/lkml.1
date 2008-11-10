Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYKJKjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYKJKjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYKJKi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:38:58 -0500
Received: from amn-trans.te.ua ([217.196.165.165]:53541 "EHLO nts.biz.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbYKJKi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:38:56 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2008 05:38:56 EST
Message-ID: <49180D47.8040203@nts.biz.ua>
Date: Mon, 10 Nov 2008 12:30:31 +0200
From: DiezelMax <max@nts.biz.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG on 2.6.28-rc4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nov 10 12:20:25 pc14 [ 2079.156711] BUG: unable to handle kernel paging 
request at 
7d8e0001                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.156716] IP: [<c01874c6>] 
__d_lookup+0x76/0x140                                                                                            
 
Nov 10 12:20:25 pc14 [ 2079.156725] *pde = 
00000000                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.156728] Oops: 0000 [#1] PREEMPT 
SMP                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.156855] last sysfs file: 
/sys/class/dmi/id/chassis_asset_tag                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.156878] Modules linked 
in:                                                                                                                
 
Nov 10 12:20:25 pc14 [ 
2079.156878]                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.156878] Pid: 30291, comm: sh Not tainted 
(2.6.28-rc4 #3) PrimePC 
Pro80                                                                     
Nov 10 12:20:25 pc14 [ 2079.156878] EIP: 0060:[<c01874c6>] EFLAGS: 
00210202 CPU: 
1                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.156878] EIP is at 
__d_lookup+0x76/0x140                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.156878] EAX: 089b05e9 EBX: 7d8e0001 ECX: 
00000011 EDX: 
f07c2000                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.156878] ESI: f07c3e98 EDI: f7402180 EBP: 
c27df100 ESP: 
f07c3e1c                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.156878]  DS: 007b ES: 007b FS: 00d8 GS: 0033 
SS: 
0068                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.156878] Process sh (pid: 30291, ti=f07c2000 
task=ebef46c0 
task.ti=f07c2000)                                                               
 
Nov 10 12:20:25 pc14 [ 2079.156878] 
Stack:                                                                                                                            
 
Nov 10 12:20:25 pc14 [ 2079.156878]  f7402180 089b05e9 c06e9dc0 00000001 
f07c3e98 c075eb20 00000005 
f07c3e8b                                                           
Nov 10 12:20:25 pc14 [ 2079.156878]  00003140 f07c3e98 f7402180 ebfd8600 
c01875ae bffffffd ebef57a0 
00007654                                                           
Nov 10 12:20:25 pc14 [ 2079.156878]  c01aea8c f07c3e8b 0000000d c064b0d6 
00007654 00000000 ebfd8600 
ebfd8600                                                           
Nov 10 12:20:25 pc14 [ 2079.156878] Call 
Trace:                                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01875ae>] 
d_lookup+0x1e/0x40                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01aea8c>] 
proc_flush_task+0xbc/0x280                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01514bf>] 
filemap_fault+0x22f/0x480                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01274f2>] 
release_task+0x22/0x2e0                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c0127d50>] 
wait_consider_task+0x5a0/0x7f0                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01280cd>] 
do_wait+0x12d/0x350                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c011fdc0>] 
default_wake_function+0x0/0x10                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c012836c>] 
sys_wait4+0x7c/0xc0                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c01283d7>] 
sys_waitpid+0x27/0x30                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.156878]  [<c0103295>] 
sysenter_do_call+0x12/0x25                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.156878] Code: d0 19 70 c0 81 e2 00 e0 ff ff 
c1 e0 02 03 05 d8 19 70 c0 83 42 14 01 8b 00 85 c0 89 c3 75 0c eb 46 8d 
74 26 00 8b 1b 85 db 74 3c <8b> 03 0f 18 00 90 8d 6b f0 8b 44 24 04 39 
45 1c 75 e8 8b 34 
24                                                                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.156878] EIP: [<c01874c6>] 
__d_lookup+0x76/0x140 SS:ESP 
0068:f07c3e1c                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.160962] ---[ end trace 1693c8301b137873 
]---                                                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.161018] note: sh[30291] exited with 
preempt_count 
1                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.161080] BUG: scheduling while atomic: 
sh/30291/0x10000002                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.161138] Modules linked 
in:                                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.161214] Pid: 30291, comm: sh Tainted: G      
D    2.6.28-rc4 
#3                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.161271] Call 
Trace:                                                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.161328]  [<c0570b99>] 
schedule+0x339/0x710                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.161388]  [<c03af79f>] 
notify_update+0x1f/0x30                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.161446]  [<c0167fd7>] 
free_pages_and_swap_cache+0x77/0xa0                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.161506]  [<c0121f33>] 
__cond_resched+0x13/0x30                                                                                                                                
 
Nov 10 12:20:25 pc14 [ 2079.161563]  [<c05710e7>] 
_cond_resched+0x27/0x30                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.161620]  [<c015e235>] 
unmap_vmas+0x525/0x5f0                                                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.161678]  [<c0161a65>] 
exit_mmap+0x95/0x150                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.161735]  [<c0123aae>] 
mmput+0x1e/0x90                                                                                                                                         
 
Nov 10 12:20:25 pc14 [ 2079.161792]  [<c0127148>] 
exit_mm+0xd8/0xf0                                                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.161850]  [<c0128596>] 
do_exit+0x106/0x7c0                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.161907]  [<c0105b89>] 
oops_end+0x89/0x90                                                                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.161964]  [<c011895f>] 
do_page_fault+0x30f/0x6c0                                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.162021]  [<c015eb6f>] 
handle_mm_fault+0x1df/0x630                                                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.162083]  [<c01817e8>] 
__link_path_walk+0xaf8/0xc50                                                                                                                            
 
Nov 10 12:20:25 pc14 [ 2079.162144]  [<c0118650>] 
do_page_fault+0x0/0x6c0                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.162206]  [<c0572bda>] 
error_code+0x72/0x78                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.162264]  [<c01874c6>] 
__d_lookup+0x76/0x140                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.162321]  [<c01875ae>] 
d_lookup+0x1e/0x40                                                                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.162378]  [<c01aea8c>] 
proc_flush_task+0xbc/0x280                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.162436]  [<c01514bf>] 
filemap_fault+0x22f/0x480                                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.162495]  [<c01274f2>] 
release_task+0x22/0x2e0                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.162552]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.162610]  [<c0127d50>] 
wait_consider_task+0x5a0/0x7f0                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.162669]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.162725]  [<c01280cd>] 
do_wait+0x12d/0x350                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.162783]  [<c011fdc0>] 
default_wake_function+0x0/0x10                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.162842]  [<c012836c>] 
sys_wait4+0x7c/0xc0                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.162898]  [<c01283d7>] 
sys_waitpid+0x27/0x30                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.162956]  [<c0103295>] 
sysenter_do_call+0x12/0x25                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.165470] BUG: scheduling while atomic: 
sh/30291/0x10000002                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.165534] Modules linked 
in:                                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.165615] Pid: 30291, comm: sh Tainted: G      
D    2.6.28-rc4 
#3                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.165678] Call 
Trace:                                                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.165742]  [<c0570b99>] 
schedule+0x339/0x710                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.165803]  [<c011d511>] 
__wake_up_sync+0x41/0x80                                                                                                                                
 
Nov 10 12:20:25 pc14 [ 2079.165863]  [<c0186a9c>] 
dput+0x1c/0x110                                                                                                                                         
 
Nov 10 12:20:25 pc14 [ 2079.165922]  [<c018c2c8>] 
mntput_no_expire+0x18/0xf0                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.165981]  [<c0121f33>] 
__cond_resched+0x13/0x30                                                                                                                                
 
Nov 10 12:20:25 pc14 [ 2079.166041]  [<c05710e7>] 
_cond_resched+0x27/0x30                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.166099]  [<c0127327>] 
put_files_struct+0x97/0xb0                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.166158]  [<c01285a4>] 
do_exit+0x114/0x7c0                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.166218]  [<c0105b89>] 
oops_end+0x89/0x90                                                                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.166279]  [<c011895f>] 
do_page_fault+0x30f/0x6c0                                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.166340]  [<c015eb6f>] 
handle_mm_fault+0x1df/0x630                                                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.166402]  [<c01817e8>] 
__link_path_walk+0xaf8/0xc50                                                                                                                            
 
Nov 10 12:20:25 pc14 [ 2079.166463]  [<c0118650>] 
do_page_fault+0x0/0x6c0                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.166525]  [<c0572bda>] 
error_code+0x72/0x78                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 2079.166583]  [<c01874c6>] 
__d_lookup+0x76/0x140                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.166641]  [<c01875ae>] 
d_lookup+0x1e/0x40                                                                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.166700]  [<c01aea8c>] 
proc_flush_task+0xbc/0x280                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.166760]  [<c01514bf>] 
filemap_fault+0x22f/0x480                                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.166819]  [<c01274f2>] 
release_task+0x22/0x2e0                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.166889]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.166948]  [<c0127d50>] 
wait_consider_task+0x5a0/0x7f0                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.167011]  [<c0151290>] 
filemap_fault+0x0/0x480                                                                                                                                 
 
Nov 10 12:20:25 pc14 [ 2079.167070]  [<c01280cd>] 
do_wait+0x12d/0x350                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.167128]  [<c011fdc0>] 
default_wake_function+0x0/0x10                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.167187]  [<c012836c>] 
sys_wait4+0x7c/0xc0                                                                                                                                     
 
Nov 10 12:20:25 pc14 [ 2079.167247]  [<c01283d7>] 
sys_waitpid+0x27/0x30                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.167308]  [<c0103295>] 
sysenter_do_call+0x12/0x25                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.514613] BUG: unable to handle kernel paging 
request at 
7d8e0001                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.514723] IP: [<c01874c6>] 
__d_lookup+0x76/0x140                                                                                                                                
 
Nov 10 12:20:25 pc14 [ 2079.514810] *pde = 
00000000                                                                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.514886] Oops: 0000 [#2] PREEMPT 
SMP                                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.515008] last sysfs file: 
/sys/class/dmi/id/chassis_asset_tag                                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.515066] Modules linked 
in:                                                                                                                                                    
 
Nov 10 12:20:25 pc14 [ 
2079.515142]                                                                                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.515194] Pid: 3415, comm: htop Tainted: 
G      D    (2.6.28-rc4 #3) PrimePC 
Pro80                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.515281] EIP: 0060:[<c01874c6>] EFLAGS: 
00010202 CPU: 
0                                                                                                                        
 
Nov 10 12:20:25 pc14 [ 2079.515337] EIP is at 
__d_lookup+0x76/0x140                                                                                                                                       
 
Nov 10 12:20:25 pc14 [ 2079.515391] EAX: 089b05e9 EBX: 7d8e0001 ECX: 
00000011 EDX: 
efbac000                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.515448] ESI: efbadf0c EDI: f7402180 EBP: 
c27df100 ESP: 
efbadea0                                                                                                               
 
Nov 10 12:20:25 pc14 [ 2079.515506]  DS: 007b ES: 007b FS: 00d8 GS: 0033 
SS: 
0068                                                                                                                         
 
Nov 10 12:20:25 pc14 [ 2079.515564] Process htop (pid: 3415, ti=efbac000 
task=f79332a0 
task.ti=efbac000)                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.515651] 
Stack:                                                                                                                                                                
 
Nov 10 12:20:25 pc14 [ 2079.515705]  f7402180 089b05e9 c309cf88 ffffffff 
efbadf0c f76f1500 00000005 
efbadf57                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.515916]  00003142 efbadf0c f7402180 efbadf57 
c01875ae 089b05e9 00007654 
00000005                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.516194]  c01ad080 0000774f c069fd84 c069fd8c 
c013613c 0000764f c0184760 
efbadf94                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.516464] Call 
Trace:                                                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01875ae>] 
d_lookup+0x1e/0x40                                                                                                                                      
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01ad080>] 
proc_fill_cache+0x60/0x140                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c013613c>] 
next_pidmap+0x3c/0x60                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c0184760>] 
filldir+0x0/0xe0                                                                                                                                        
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01afed7>] 
proc_pid_readdir+0xc7/0x190                                                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01ae560>] 
proc_pid_instantiate+0x0/0x80                                                                                                                           
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c0184760>] 
filldir+0x0/0xe0                                                                                                                                        
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01acc8c>] 
proc_root_readdir+0x4c/0x90                                                                                                                             
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c0184760>] 
filldir+0x0/0xe0                                                                                                                                        
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c01848c1>] 
vfs_readdir+0x81/0xa0                                                                                                                                   
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c0184b5b>] 
sys_getdents+0x6b/0xc0                                                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.516464]  [<c0103295>] 
sysenter_do_call+0x12/0x25                                                                                                                              
 
Nov 10 12:20:25 pc14 [ 2079.516464] Code: d0 19 70 c0 81 e2 00 e0 ff ff 
c1 e0 02 03 05 d8 19 70 c0 83 42 14 01 8b 00 85 c0 89 c3 75 0c eb 46 8d 
74 26 00 8b 1b 85 db 74 3c <8b> 03 0f 18 00 90 8d 6b f0 8b 44 24 04 39 
45 1c 75 e8 8b 34 
24                                                                                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.516464] EIP: [<c01874c6>] 
__d_lookup+0x76/0x140 SS:ESP 
0068:efbadea0                                                                                                          
 
Nov 10 12:20:25 pc14 [ 2079.519193] ---[ end trace 1693c8301b137873 
]---                                                                                                                                  
 
Nov 10 12:20:25 pc14 [ 2079.519252] note: htop[3415] exited with 
preempt_count 1



Linux pc14 2.6.28-rc4 #3 SMP PREEMPT Mon Nov 10 11:36:02 EET 2008 i686 
Intel(R) Pentium(R) Dual CPU E2180 @ 2.00GHz GenuineIntel GNU/Linux

Gnu C                  4.2.4
Gnu make               3.81
binutils               2.19
util-linux             2.14.1
mount                  support
module-init-tools      3.5
e2fsprogs              1.41.3
reiserfsprogs          3.6.19
Linux C Library        2.8
Dynamic linker (ldd)   2.8
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               6.12
Modules Loaded


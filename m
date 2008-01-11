Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYAKGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYAKGAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYAKGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:00:20 -0500
Received: from rosi.naasa.net ([212.8.0.13]:45139 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYAKGAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:00:16 -0500
X-Greylist: delayed 1824 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 01:00:15 EST
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Fri, 11 Jan 2008 06:29:47 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801101103.06688.lists@naasa.net> <400029009.12072@ustc.edu.cn>
In-Reply-To: <400029009.12072@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801110629.48569.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. Januar 2008 schrieb Fengguang Wu:

> Joerg, what's the output of `dumpe2fs /dev/sda7` and `lsof|grep /tmp`?

Fengang, here is the output (kernel 2.6.24-rc7 without your patches):

Filesystem volume name:   TMP
Last mounted on:          <not available>
Filesystem UUID:          e23ae961-bbdc-44bc-b662-f28f7314939b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal resize_inode dir_index filetype 
sparse_super large_file
Filesystem flags:         signed directory hash
Default mount options:    (none)
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              244320
Block count:              487966
Reserved block count:     24398
Free blocks:              468728
Free inodes:              244162
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      119
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         16288
Inode blocks per group:   509
Filesystem created:       Thu Feb  8 18:46:19 2007
Last mount time:          Thu Jan 10 11:09:35 2008
Last write time:          Fri Jan 11 06:12:58 2008
Mount count:              25
Maximum mount count:      39
Last checked:             Tue Dec 11 22:07:03 2007
Check interval:           15552000 (6 months)
Next check after:         Sun Jun  8 23:07:03 2008
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      79e271e9-b874-4e11-92b0-cdb36d07e1c1
Journal backup:           inode blocks
Journal size:             32M


Group 0: (Blocks 0-32767)
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-120
  Block bitmap at 121 (+121), Inode bitmap at 122 (+122)
  Inode table at 123-631 (+123)
  23926 free blocks, 16275 free inodes, 2 directories
  Free blocks: 638-10239, 16384, 18444-30719, 30721-32767
  Free inodes: 14-16288
Group 1: (Blocks 32768-65535)
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32888
  Block bitmap at 32889 (+121), Inode bitmap at 32890 (+122)
  Inode table at 32891-33399 (+123)
  32135 free blocks, 16287 free inodes, 1 directories
  Free blocks: 33400-57343, 57345-65535
  Free inodes: 16290-32576
Group 2: (Blocks 65536-98303)
  Block bitmap at 65536 (+0), Inode bitmap at 65537 (+1)
  Inode table at 65538-66046 (+2)
  32256 free blocks, 16286 free inodes, 1 directories
  Free blocks: 66047-96255, 96257-98303
  Free inodes: 32579-48864
Group 3: (Blocks 98304-131071)
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98424
  Block bitmap at 98425 (+121), Inode bitmap at 98426 (+122)
  Inode table at 98427-98935 (+123)
  32135 free blocks, 16286 free inodes, 1 directories
  Free blocks: 98936-120831, 120833-131071
  Free inodes: 48867-65152
Group 4: (Blocks 131072-163839)
  Block bitmap at 131072 (+0), Inode bitmap at 131073 (+1)
  Inode table at 131074-131582 (+2)
  32256 free blocks, 16287 free inodes, 1 directories
  Free blocks: 131583-133119, 133121-163839
  Free inodes: 65154-81440
Group 5: (Blocks 163840-196607)
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-163960
  Block bitmap at 163961 (+121), Inode bitmap at 163962 (+122)
  Inode table at 163963-164471 (+123)
  32135 free blocks, 16286 free inodes, 1 directories
  Free blocks: 164472-182271, 182273-196607
  Free inodes: 81443-97728
Group 6: (Blocks 196608-229375)
  Block bitmap at 196608 (+0), Inode bitmap at 196609 (+1)
  Inode table at 196610-197118 (+2)
  32087 free blocks, 16265 free inodes, 1 directories
  Free blocks: 197119-200703, 200705-210943, 210945-210951, 210970-210975, 
210988-215039, 215041-215047, 215058-215071, 215090-217087, 217089-219135, 
219137-219143, 219177-219199, 219226-219255, 219257-219263, 219265-219271, 
219274-219279, 219305-219335, 219337-219343, 219345-219351, 219354-219359, 
219371-219383, 219385-227327, 227331-229375
  Free inodes: 97752-114016
Group 7: (Blocks 229376-262143)
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229496
  Block bitmap at 229497 (+121), Inode bitmap at 229498 (+122)
  Inode table at 229499-230007 (+123)
  32134 free blocks, 16278 free inodes, 1 directories
  Free blocks: 230008-253951, 253953-260095, 260097-262143
  Free inodes: 114022, 114025-114027, 114031-130304
Group 8: (Blocks 262144-294911)
  Block bitmap at 262144 (+0), Inode bitmap at 262145 (+1)
  Inode table at 262146-262654 (+2)
  29809 free blocks, 16193 free inodes, 17 directories
  Free blocks: 262661-264191, 264244, 264250, 264263, 264272, 264281, 
264288-266239, 266870-266871, 266877-268287, 268289-270335, 270965-274431, 
274434-282623, 282625-290815, 291897-292863, 292866-294911
  Free inodes: 130316, 130319, 130388, 130402-130406, 130408-146592
Group 9: (Blocks 294912-327679)
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-295032
  Block bitmap at 295033 (+121), Inode bitmap at 295034 (+122)
  Inode table at 295035-295543 (+123)
  32135 free blocks, 16286 free inodes, 1 directories
  Free blocks: 295544-313343, 313345-327679
  Free inodes: 146595-162880
Group 10: (Blocks 327680-360447)
  Block bitmap at 327680 (+0), Inode bitmap at 327681 (+1)
  Inode table at 327682-328190 (+2)
  32256 free blocks, 16283 free inodes, 1 directories
  Free blocks: 328191-342015, 342017-360447
  Free inodes: 162886-179168
Group 11: (Blocks 360448-393215)
  Block bitmap at 360448 (+0), Inode bitmap at 360449 (+1)
  Inode table at 360450-360958 (+2)
  32248 free blocks, 16286 free inodes, 1 directories
  Free blocks: 360959-372735, 372744-380927, 380929-393215
  Free inodes: 179171-195456
Group 12: (Blocks 393216-425983)
  Block bitmap at 393216 (+0), Inode bitmap at 393217 (+1)
  Inode table at 393218-393726 (+2)
  32257 free blocks, 16288 free inodes, 0 directories
  Free blocks: 393727-425983
  Free inodes: 195457-211744
Group 13: (Blocks 425984-458751)
  Block bitmap at 425984 (+0), Inode bitmap at 425985 (+1)
  Inode table at 425986-426494 (+2)
  32256 free blocks, 16287 free inodes, 1 directories
  Free blocks: 426495-436223, 436225-458751
  Free inodes: 211746-228032
Group 14: (Blocks 458752-487965)
  Block bitmap at 458752 (+0), Inode bitmap at 458753 (+1)
  Inode table at 458754-459262 (+2)
  28703 free blocks, 16288 free inodes, 0 directories
  Free blocks: 459263-487965
  Free inodes: 228033-244320

konqueror   987    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror   987    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror   987    jplatte   13u      REG        8,7      579      
97731 /tmp/kde-jplatte/konqueror-crash-Jv2u8a.log
konqueror   987    jplatte   14u      REG        8,7   128289      
97734 /tmp/kde-jplatte/khtmlcacheA7VjAa.tmp (deleted)
konqueror   987    jplatte   16u      REG        8,7    43334      
97750 /tmp/kde-jplatte/khtmlcacheZUNlsc.tmp (deleted)
konqueror   987    jplatte   22u      REG        8,7      797      
97751 /tmp/kde-jplatte/khtmlcache76bZYa.tmp (deleted)
konqueror   987    jplatte   27u      REG        8,7   102347      
97735 /tmp/kde-jplatte/khtmlcacheMhlDJb.tmp (deleted)
konqueror   987    jplatte   31u      REG        8,7      354      
97738 /tmp/kde-jplatte/khtmlcacheq21uoc.tmp (deleted)
konqueror   987    jplatte   32u      REG        8,7     1360      
97742 /tmp/kde-jplatte/khtmlcacheo2Ms2a.tmp (deleted)
konqueror   987    jplatte   34u      REG        8,7     6378      
97745 /tmp/kde-jplatte/khtmlcacheLETtgc.tmp (deleted)
konqueror   987    jplatte   35u      REG        8,7    97350      
97746 /tmp/kde-jplatte/khtmlcache5jit8a.tmp (deleted)
konqueror   987    jplatte   36u      REG        8,7      354      
97747 /tmp/kde-jplatte/khtmlcache7VBSNa.tmp (deleted)
konqueror   987    jplatte   37u      REG        8,7     1360      
97748 /tmp/kde-jplatte/khtmlcachetSNbub.tmp (deleted)
konqueror   987    jplatte   38u      REG        8,7     6073      
97749 /tmp/kde-jplatte/khtmlcacheKAKhuc.tmp (deleted)
xfs        5503       root    3u     unix 0xdfdd7e00               
15884 /tmp/.font-unix/fs7100
xfs        5503       root    4u     unix 0xf724ee00               
18389 /tmp/.font-unix/fs7100
Xorg       6031       root    1u     unix 0xf7151000               
17447 /tmp/.X11-unix/X0
Xorg       6031       root    3u     unix 0xf40f5540              
108479 /tmp/.X11-unix/X0
Xorg       6031       root   10u     unix 0xf400ec40              
107863 /tmp/.X11-unix/X0
Xorg       6031       root   13u     unix 0xf724ea80               
18532 /tmp/.X11-unix/X0
Xorg       6031       root   14u     unix 0xf6702000               
18880 /tmp/.X11-unix/X0
Xorg       6031       root   15u     unix 0xf5d6ac40               
19298 /tmp/.X11-unix/X0
Xorg       6031       root   16u     unix 0xf5297c40               
25334 /tmp/.X11-unix/X0
Xorg       6031       root   17u     unix 0xf410b1c0               
31056 /tmp/.X11-unix/X0
Xorg       6031       root   18u     unix 0xf67021c0               
19002 /tmp/.X11-unix/X0
Xorg       6031       root   19u     unix 0xf5c7f700               
19014 /tmp/.X11-unix/X0
Xorg       6031       root   20u     unix 0xf5051380               
20514 /tmp/.X11-unix/X0
Xorg       6031       root   21u     unix 0xf5ccc540               
19100 /tmp/.X11-unix/X0
Xorg       6031       root   22u     unix 0xf5c7fa80               
19086 /tmp/.X11-unix/X0
Xorg       6031       root   23u     unix 0xf725c380               
19123 /tmp/.X11-unix/X0
Xorg       6031       root   24u     unix 0xf5d29380               
19147 /tmp/.X11-unix/X0
Xorg       6031       root   25u     unix 0xf5174700               
31277 /tmp/.X11-unix/X0
Xorg       6031       root   26u     unix 0xf5db3380               
19252 /tmp/.X11-unix/X0
Xorg       6031       root   27u     unix 0xf51ce8c0               
41610 /tmp/.X11-unix/X0
Xorg       6031       root   28u     unix 0xf5de8e00               
19379 /tmp/.X11-unix/X0
Xorg       6031       root   29u     unix 0xf5e0b8c0               
19401 /tmp/.X11-unix/X0
Xorg       6031       root   30u     unix 0xf5e5c540               
19419 /tmp/.X11-unix/X0
Xorg       6031       root   31u     unix 0xf5e9ba80               
19500 /tmp/.X11-unix/X0
Xorg       6031       root   32u     unix 0xf5e0ba80               
19515 /tmp/.X11-unix/X0
Xorg       6031       root   33u     unix 0xf5e7fa80               
19531 /tmp/.X11-unix/X0
Xorg       6031       root   34u     unix 0xf5ea61c0               
19982 /tmp/.X11-unix/X0
Xorg       6031       root   35u     unix 0xf5ea6a80               
19991 /tmp/.X11-unix/X0
Xorg       6031       root   36u     unix 0xf7220000               
20286 /tmp/.X11-unix/X0
Xorg       6031       root   37u     unix 0xf5187700               
54906 /tmp/.X11-unix/X0
Xorg       6031       root   39u     unix 0xf5187e00               
43577 /tmp/.X11-unix/X0
Xorg       6031       root   40u     unix 0xf5ec9a80               
20377 /tmp/.X11-unix/X0
Xorg       6031       root   41u     unix 0xf51b2380               
20809 /tmp/.X11-unix/X0
Xorg       6031       root   42u     unix 0xf71921c0               
20455 /tmp/.X11-unix/X0
Xorg       6031       root   43u     unix 0xf528a1c0               
99356 /tmp/.X11-unix/X0
Xorg       6031       root   44u     unix 0xf5297540               
21298 /tmp/.X11-unix/X0
Xorg       6031       root   45u     unix 0xf5099c40               
20549 /tmp/.X11-unix/X0
Xorg       6031       root   46u     unix 0xf50ff380               
20600 /tmp/.X11-unix/X0
Xorg       6031       root   47u     unix 0xf510c8c0               
20655 /tmp/.X11-unix/X0
Xorg       6031       root   48u     unix 0xf510cc40               
20657 /tmp/.X11-unix/X0
Xorg       6031       root   49u     unix 0xf5138540               
20663 /tmp/.X11-unix/X0
Xorg       6031       root   50u     unix 0xf50cb380               
20683 /tmp/.X11-unix/X0
Xorg       6031       root   51u     unix 0xf51b2e00               
20883 /tmp/.X11-unix/X0
Xorg       6031       root   52u     unix 0xf52c3a80               
21316 /tmp/.X11-unix/X0
Xorg       6031       root   53u     unix 0xf52f3a80               
21373 /tmp/.X11-unix/X0
Xorg       6031       root   54u     unix 0xf528ac40               
21871 /tmp/.X11-unix/X0
Xorg       6031       root   55u     unix 0xdfd301c0               
25107 /tmp/.X11-unix/X0
Xorg       6031       root   56u     unix 0xf67ab380               
25380 /tmp/.X11-unix/X0
Xorg       6031       root   58u     unix 0xf512c700               
49503 /tmp/.X11-unix/X0
Xorg       6031       root   59u     unix 0xf51cee00               
55093 /tmp/.X11-unix/X0
Xorg       6031       root   60u     unix 0xf5187a80               
54949 /tmp/.X11-unix/X0
kontact    6669    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kontact    6669    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kontact    6669    jplatte   20u     unix 0xf5005000              
109900 /tmp/ksocket-jplatte/kontactb5GSMb.slave-socket
kontact    6669    jplatte   33u     unix 0xf712a700              
108568 /tmp/ksocket-jplatte/kontact7somnc.slave-socket
kontact    6669    jplatte   34u     unix 0xf50d78c0              
108570 /tmp/ksocket-jplatte/kontactQdchTb.slave-socket
kontact    6669    jplatte   36u     unix 0xf50d7000              
108569 /tmp/ksocket-jplatte/kontactdlqZ9b.slave-socket
kio_imap4  6691    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_imap4  6691    jplatte   10r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_imap4  6698    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_imap4  6698    jplatte   10r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_imap4  6699    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_imap4  6699    jplatte   10r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
gam_serve  6972       root  cwd       DIR        8,7        0     
211745 /tmp/1878472609 (deleted)
ssh-agent  7097    jplatte    3u     unix 0xf724f1c0               
18873 /tmp/ssh-gdxKKv7049/agent.7049
gpg-agent  7098    jplatte    5u     unix 0xf724f540               
18877 /tmp/gpg-cKJSSb/S.gpg-agent
kdeinit    7159    jplatte    9u     unix 0xf5c2ba80               
18966 /tmp/ksocket-jplatte/kdeinit__0
kdeinit    7159    jplatte   10u     unix 0xf5c2bc40               
18968 /tmp/ksocket-jplatte/kdeinit-
dcopserve  7162    jplatte    6u     unix 0xf5c7f380               
19011 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte    8u     unix 0xf5c891c0               
18977 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   11u     unix 0xf5c89e00               
18993 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   12u     unix 0xf5cd6700               
20495 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   13u     unix 0xf5c2b1c0               
19092 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   14u     unix 0xf5d1d540               
19107 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   15u     unix 0xf5dd5e00               
19295 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   16u     unix 0xf725c000               
19118 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   17u     unix 0xf725ce00               
19142 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   18u     unix 0xf5ee9000              
108474 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   20u     unix 0xf5db3000               
19249 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   21u     unix 0xf5db3540               
19264 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   22u     unix 0xf51cea80              
108608 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   23u     unix 0xf5de81c0               
19376 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   24u     unix 0xf7161700               
20283 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   25u     unix 0xf400e000              
108491 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   26u     unix 0xf5e0b540               
19398 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   27u     unix 0xf5e9b700               
19497 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   28u     unix 0xf5e5c1c0               
19416 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   29u     unix 0xf5de8c40               
19541 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   30u     unix 0xf400e700              
108493 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   31u     unix 0xf5ea4a80               
20007 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   32u     unix 0xf5e7f700               
19526 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   33u     unix 0xf5ea6e00               
19993 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   34u     unix 0xf400e380              
108495 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   35u     unix 0xf50ff540              
108497 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   36u     unix 0xf5cb0000              
108499 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   37u     unix 0xf5ec9380               
20374 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   38u     unix 0xf5cb0700              
108501 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   39u     unix 0xf5cb01c0              
108503 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   40u     unix 0xf514b8c0               
20914 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   41u     unix 0xf506be00               
21019 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   42u     unix 0xf5cd6a80               
20506 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   43u     unix 0xf51ce540              
108610 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   44u     unix 0xf5099380               
20542 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   45u     unix 0xf50998c0               
20546 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   46u     unix 0xf5138c40               
20680 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   47u     unix 0xdfd4fc40               
99363 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   49u     unix 0xf50ff000               
20597 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   50u     unix 0xf724f700               
99470 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   51u     unix 0xf50ffe00               
20616 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   54u     unix 0xf50fd8c0               
20623 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   56u     unix 0xf510c380               
20649 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   58u     unix 0xf6702c40              
108612 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   60u     unix 0xf50d7e00               
20764 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   74u     unix 0xf5255540               
43572 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   88u     unix 0xf407da80               
25329 /tmp/.ICE-unix/dcop7162-1199959838
dcopserve  7162    jplatte   89u     unix 0xf6702540               
25375 /tmp/.ICE-unix/dcop7162-1199959838
klauncher  7164    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
klauncher  7164    jplatte   10r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
klauncher  7164    jplatte   11u     unix 0xf5c89540               
18999 /tmp/ksocket-jplatte/klauncherDCSyUa.slave-socket
klauncher  7164    jplatte   12u     unix 0xf5255a80              
110308 /tmp/ksocket-jplatte/klauncherDCSyUa.slave-socket
kded       7166    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kded       7166    jplatte   14r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
ksmserver  7183    jplatte    7u     unix 0xf5ccc8c0               
19076 /tmp/ksocket-jplatte/kdeinit__0
ksmserver  7183    jplatte   12u     unix 0xf5c2b8c0               
19093 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   13u     unix 0xf5d1d1c0               
19102 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   14u     unix 0xf5d1d8c0               
19110 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   15u     unix 0xf725ca80               
19127 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   16u     unix 0xf5d298c0               
19151 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   17u     unix 0xf5db3a80               
19256 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   18u     unix 0xf5c2b000               
19306 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   19u     unix 0xdfdd7700               
19472 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   20u     unix 0xf5c7fc40               
19384 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   21u     unix 0xf5dddc40               
19405 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   22u     unix 0xf712a380               
20290 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   23u     unix 0xf5e5ca80               
19504 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   24u     unix 0xf5e7f1c0               
19517 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   25u     unix 0xf5e7fe00               
19533 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   26u     unix 0xf5ea6700               
19984 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   27u     unix 0xf5ea4380               
19995 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   28u     unix 0xf5d6aa80               
43581 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   29u     unix 0xf40f5700              
108483 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   30u     unix 0xdfd4f1c0               
99358 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   31u     unix 0xf5ee9e00               
20381 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   32u     unix 0xf5005700               
20467 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   34u     unix 0xf512c1c0               
21389 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   35u     unix 0xf50cbc40               
20568 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   36u     unix 0xf50e4000               
20571 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   37u     unix 0xf400e540               
25338 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   38u     unix 0xf50e4700               
20575 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   39u     unix 0xf50ffa80               
20604 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   40u     unix 0xf51381c0               
20665 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   41u     unix 0xf514b380               
20693 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   42u     unix 0xf514b540               
20851 /tmp/.ICE-unix/7183
ksmserver  7183    jplatte   43u     unix 0xf52c3700               
25384 /tmp/.ICE-unix/7183
kicker     7192    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kicker     7192    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kxkb       7215    jplatte   12r      REG        8,7    11912      
97730 /tmp/kde-jplatte/de..xkm
konqueror  7255    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror  7255    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror  7255    jplatte   13u      REG        8,7      283      
97732 /tmp/kde-jplatte/konqueror-crash-LPnWVb.log
konqueror  7255    jplatte   18u      REG        8,7    67736      
97740 /tmp/kde-jplatte/khtmlcacheJfHsua.tmp (deleted)
konqueror  7255    jplatte   21u      REG        8,7    48368      
97741 /tmp/kde-jplatte/khtmlcache8KkbLa.tmp (deleted)
konqueror  7337    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror  7337    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
konqueror  7337    jplatte   13u      REG        8,7      102      
97733 /tmp/kde-jplatte/konqueror-crash-YtoSma.log
konqueror  7337    jplatte   16u      REG        8,7    37907      
97743 /tmp/kde-jplatte/khtmlcacheemjbkb.tmp (deleted)
konqueror  7337    jplatte   22u      REG        8,7    66887      
97744 /tmp/kde-jplatte/khtmlcache1u4D4b.tmp (deleted)
amarokapp  7351    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
amarokapp  7351    jplatte   18r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kopete     7447    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kopete     7447    jplatte   12r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kdeinit    7647       root  cwd       DIR        8,7     4096     
130305 /tmp/1878472609
kdeinit    7647       root    7u     unix 0xf51ce1c0               
21255 /tmp/1878472609/.kde/socket-ibm/kdeinit__0
kdeinit    7647       root    8u     unix 0xf67ab8c0               
21257 /tmp/1878472609/.kde/socket-ibm/kdeinit-
dcopserve  7651       root  cwd       DIR        8,7     4096     
130305 /tmp/1878472609
dcopserve  7651       root    5u     unix 0xf5297000               
21279 /tmp/.ICE-unix/dcop7651-1199959912
dcopserve  7651       root    7u     unix 0xf67abc40               
21265 /tmp/.ICE-unix/dcop7651-1199959912
dcopserve  7651       root   10u     unix 0xf52c3000               
21308 /tmp/.ICE-unix/dcop7651-1199959912
dcopserve  7651       root   11u     unix 0xdfd30c40               
25104 /tmp/.ICE-unix/dcop7651-1199959912
klauncher  7653       root  cwd       DIR        8,7     4096     
130305 /tmp/1878472609
klauncher  7653       root  mem       REG        8,7              
130321 /tmp/1878472609/.kde/cache-ibm/ksycoca (path inode=130326)
klauncher  7653       root    9r      REG        8,7  2564654     
130321 /tmp/1878472609/.kde/cache-ibm/ksycoca
klauncher  7653       root   10u     unix 0xf5297a80               
21295 /tmp/1878472609/.kde/socket-ibm/klauncher1FOdCb.slave-socket
kded       7662       root  cwd       DIR        8,7     4096     
130305 /tmp/1878472609
kded       7662       root  mem       REG        8,7  2564654     
130326 /tmp/1878472609/.kde/cache-ibm/ksycoca
kded       7662       root   12r      REG        8,7  2564654     
130326 /tmp/1878472609/.kde/cache-ibm/ksycoca
kio_smtp   7710    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_smtp   7710    jplatte    9r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_file   7786    jplatte  mem       REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
kio_file   7786    jplatte    9r      REG        8,6  2590525    
1336104 /var/tmp/kdecache-jplatte/ksycoca
java      10922    jplatte  mem       REG        8,7    32768     
179170 /tmp/hsperfdata_jplatte/10922

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZA3TaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZA3TaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZA3TaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:30:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:16630 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZA3TaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=llA6cNGJXwPYJUA2NKY7zJaXkMLtGasGt3g1dV3/Ku/UuDDtBkkpF8HZcquKH04od2
         ptxPH3sG87o5GY/9ZS9bW0Rs/vDVTxnqCoN5yBDBJSir2y8st+uC8BI6XNBhNRaIKJmv
         4nlMAmzxiZMH50X3lLYQ9yWUwKSdYouK/VoGc=
Message-ID: <4983553A.2010804@gmail.com>
Date: Fri, 30 Jan 2009 11:30:02 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: headers check garble latest git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when compiling the kernel I see lots
of this:

/home/kernel/2.6.29/usr/include/linux/acct.h:62: leaks CONFIG_M68K to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/aio_abi.h:58: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/atalk.h:15: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/atmbr2684.h:88: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/atmdev.h:103: leaks CONFIG_COMPAT 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/auto_fs4.h:132: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/bfs_fs.h:24: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/blktrace_api.h:96: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/capability.h:72: leaks 
CONFIG_SECURITY to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/capability.h:73: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/cdrom.h:155: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/cgroupstats.h:31: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/cm4000_cs.h:22: leaks 
CONFIG_COMPAT to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/coda_psdev.h:90: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/dlm_plock.h:25: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/dn.h:75: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/edd.h:70: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/efs_fs_sb.h:49: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/elf-fdpic.h:61: leaks CONFIG_MMU 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/elf-fdpic.h:62: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/elf.h:379: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/elf.h:387: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/elf.h:401: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/elf.h:402: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/elfcore.h:59: leaks CONFIG_BINFMT 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/errqueue.h:6: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/fb.h:381: leaks CONFIG_FB to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/genetlink.h:12: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/gfs2_ondisk.h:109: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/hid.h:66: leaks CONFIG_HID to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/hid.h:69: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/hid.h:76: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/hiddev.h:40: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/icmpv6.h:8: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_addr.h:8: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_addrlabel.h:15: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_fc.h:37: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_hippi.h:82: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_link.h:9: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_ppp.h:96: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_strip.h:22: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/if_tr.h:37: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/igmp.h:31: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/in6.h:47: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/in6.h:49: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/inet_diag.h:16: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/ip6_tunnel.h:21: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/ipv6.h:26: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/ipv6_route.h:42: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/ipx.h:13: found __[us]{8,16,32,64} 
type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/irda.h:127: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/kernel.h:39: leaks CONFIG_NUMA to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kernel.h:40: leaks CONFIG_NUMA to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kernel.h:46: leaks CONFIG_FTRACE 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kernel.h:47: leaks CONFIG_FTRACE 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kvm.h:61: leaks CONFIG_X86 to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kvm.h:64: leaks CONFIG_X86 to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kvm.h:387: leaks CONFIG_X86 to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kvm.h:391: leaks CONFIG_X86 to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/kvm.h:396: leaks CONFIG_X86 to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/minix_fs.h:34: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/msdos_fs.h:100: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/neighbour.h:8: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/nfs_idmap.h:55: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/nubus.h:232: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/nubus.h:296: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/nubus.h:298: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/nubus.h:302: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/phonet.h:50: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/pkt_cls.h:122: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/pkt_cls.h:306: leaks CONFIG_NET to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/pkt_cls.h:307: leaks CONFIG_NET to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/pkt_sched.h:32: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/pktcdvd.h:36: leaks CONFIG_CDROM 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/ppp_defs.h:50: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/random.h:39: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/raw.h:16: leaks CONFIG_MAX to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:64: leaks 
CONFIG_REISERFS to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:81: leaks 
CONFIG_REISERFS to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:687: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:995: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:997: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1467: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1587: leaks 
CONFIG_QUOTA to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1760: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1764: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1766: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1769: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1771: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1805: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1908: leaks 
CONFIG_PROC to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1948: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1949: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1950: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1951: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1962: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1963: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/reiserfs_fs.h:1964: extern's make 
no sense in userspace
/home/kernel/2.6.29/usr/include/linux/rtnetlink.h:328: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/signalfd.h:19: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/socket.h:27: leaks CONFIG_PROC to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/socket.h:29: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/socket.h:262: leaks CONFIG_COMPAT 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/sound.h:33: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:34: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:35: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:36: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:37: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:39: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:40: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:41: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/sound.h:42: extern's make no sense 
in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1047: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1048: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1049: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1050: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1051: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1053: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1055: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1056: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1061: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1062: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1078: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/soundcard.h:1079: extern's make no 
sense in userspace
/home/kernel/2.6.29/usr/include/linux/synclink.h:209: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/taskstats.h:44: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/types.h:114: leaks CONFIG_LBD to 
userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/video_decoder.h:7: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/video_encoder.h:5: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/videodev.h:18: leaks CONFIG_VIDEO 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/videodev.h:53: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/videodev.h:313: leaks CONFIG_VIDEO 
to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/videodev2.h:1477: leaks 
CONFIG_VIDEO to userspace where it is not valid
/home/kernel/2.6.29/usr/include/linux/virtio_blk.h:21: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/virtio_console.h:15: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/linux/virtio_net.h:28: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/mtd (6 files)
/home/kernel/2.6.29/usr/include/mtd/inftl-user.h:61: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/home/kernel/2.6.29/usr/include/mtd/jffs2-user.h:20: extern's make no 
sense in userspace

as for the kernel working
(seems good to me);

regards;

Justin P. Mattock

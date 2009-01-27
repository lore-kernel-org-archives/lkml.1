Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZA0Hbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZA0Hbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZA0HbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:31:24 -0500
Received: from fb1.tech.numericable.fr ([82.216.111.51]:53054 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZA0HbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:31:19 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 02:31:18 EST
Message-ID: <497EB491.6080904@numericable.fr>
Date: Tue, 27 Jan 2009 08:15:29 +0100
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008113017)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jean Delvare <khali@linux-fr.org>,
       Takashi Iwai <tiwai@suse.de>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: [2.6.29-rc2-git2] compilation warnings
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


Here are my compilation warnings for fresh 2.6.29-rc2-git2 kernel :

> sound/pci/hda/hda_codec.c: In function ‘get_empty_pcm_device’:
> sound/pci/hda/hda_codec.c:2544: attention : ‘dev’ may be used 
> uninitialized in this function

> drivers/i2c/i2c-core.c: In function ‘i2c_new_device’:
> drivers/i2c/i2c-core.c:283: attention : ‘i2c_attach_client’ is 
> deprecated (declared at include/linux/i2c.h:434)
> drivers/i2c/i2c-core.c: In function ‘i2c_del_adapter’:
> drivers/i2c/i2c-core.c:646: attention : ‘detach_client’ is deprecated 
> (declared at include/linux/i2c.h:154)
> drivers/i2c/i2c-core.c: In function ‘i2c_register_driver’:
> drivers/i2c/i2c-core.c:713: attention : ‘detach_client’ is deprecated 
> (declared at include/linux/i2c.h:154)
> drivers/i2c/i2c-core.c: In function ‘__detach_adapter’:
> drivers/i2c/i2c-core.c:780: attention : ‘detach_client’ is deprecated 
> (declared at include/linux/i2c.h:154)
> drivers/i2c/i2c-core.c: Hors de toute fonction :
> drivers/i2c/i2c-core.c:876: attention : ‘i2c_attach_client’ is 
> deprecated (declared at drivers/i2c/i2c-core.c:827)
> drivers/i2c/i2c-core.c:876: attention : ‘i2c_attach_client’ is 
> deprecated (declared at drivers/i2c/i2c-core.c:827)
> drivers/i2c/i2c-core.c:904: attention : ‘i2c_detach_client’ is 
> deprecated (declared at drivers/i2c/i2c-core.c:879)
> drivers/i2c/i2c-core.c:904: attention : ‘i2c_detach_client’ is 
> deprecated (declared at drivers/i2c/i2c-core.c:879)

> drivers/media/video/v4l2-common.c: In function ‘v4l2_i2c_attach’:
> drivers/media/video/v4l2-common.c:875: attention : ‘i2c_attach_client’ 
> is deprecated (declared at include/linux/i2c.h:434)

> drivers/uwb/i1480/i1480-est.c:94: attention : ‘i1480_est_id_table’ 
> defined but not used

> drivers/uwb/wlp/messages.c: In function ‘wlp_parse_f0’:
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[15]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[14]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[13]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[12]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[11]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[10]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[9]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[8]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[7]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[6]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[5]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[4]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[3]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘enonce.data[2]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[15]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[14]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[13]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[12]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[11]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[10]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[9]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[8]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[7]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[6]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[5]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[4]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[3]’ may be 
> used uninitialized in this function
> drivers/uwb/wlp/messages.c:906: attention : ‘rnonce.data[2]’ may be 
> used uninitialized in this function

> drivers/uwb/whc-rc.c:451: attention : ‘whcrc_id_table’ defined but not 
> used

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/mtd/inftl-user.h:61: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/mtd/jffs2-user.h:20: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm-generic/fcntl.h:127: 
> leaks CONFIG_64BIT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm-generic/fcntl.h:149: 
> leaks CONFIG_64BIT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/can/bcm.h:29: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/audio.h:133: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/dmx.h:27: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/dmx.h:90: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/video/edid.h:4: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/sound/hdsp.h:33: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/video/sisfb.h:25: include 
> of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/video/sisfb.h:78: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/video/uvesafb.h:5: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/frontend.h:29: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/frontend.h:76: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/net.h:27: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/net.h:31: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/video.h:29: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dvb/video.h:102: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/netfilter/xt_conntrack.h:40: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/export.h:13: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/nfsfh.h:17: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/nfsfh.h:28: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/stats.h:32: 
> leaks CONFIG_NFSD to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/syscall.h:12: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/raid/md_p.h:85: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfsd/syscall.h:104: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/spi/spidev.h:83: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_act/tc_gact.h:19: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_act/tc_mirred.h:16: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_act/tc_pedit.h:19: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_ematch/tc_em_cmp.h:8: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_ematch/tc_em_meta.h:18: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_ematch/tc_em_nbyte.h:8: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>
> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/tc_ematch/tc_em_text.h:11: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/usb/cdc.h:50: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/acct.h:62: leaks 
> CONFIG_M68K to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/aio_abi.h:58: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/atalk.h:15: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/atmbr2684.h:88: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/usb/gadgetfs.h:21: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/atmdev.h:103: leaks 
> CONFIG_COMPAT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/auto_fs4.h:132: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/bfs_fs.h:24: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/blktrace_api.h:96: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/capability.h:72: 
> leaks CONFIG_SECURITY to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/capability.h:73: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/cdrom.h:155: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/cgroupstats.h:31: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/cm4000_cs.h:22: 
> leaks CONFIG_COMPAT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/coda_psdev.h:90: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dlm_plock.h:25: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/dn.h:75: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/edd.h:70: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/efs_fs_sb.h:49: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf-fdpic.h:61: 
> leaks CONFIG_MMU to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf-fdpic.h:62: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf.h:379: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf.h:387: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf.h:401: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elf.h:402: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/elfcore.h:59: leaks 
> CONFIG_BINFMT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/errqueue.h:6: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/fb.h:381: leaks 
> CONFIG_FB to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/flat.h:16: leaks 
> CONFIG_BINFMT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/genetlink.h:12: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/gfs2_ondisk.h:109: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/hid.h:66: leaks 
> CONFIG_HID to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/hid.h:69: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/hid.h:76: extern's 
> make no sense in userspace


> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/hiddev.h:40: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/icmpv6.h:8: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_addr.h:8: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_addrlabel.h:15: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_fc.h:37: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_hippi.h:82: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_link.h:9: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_ppp.h:96: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_strip.h:22: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/if_tr.h:37: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/igmp.h:31: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/in6.h:47: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/in6.h:49: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/inet_diag.h:16: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/ip6_tunnel.h:21: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/ipv6.h:26: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/ipv6_route.h:42: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/ipx.h:13: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/irda.h:127: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kernel.h:39: leaks 
> CONFIG_NUMA to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kernel.h:40: leaks 
> CONFIG_NUMA to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kernel.h:46: leaks 
> CONFIG_FTRACE to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kernel.h:47: leaks 
> CONFIG_FTRACE to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kvm.h:61: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kvm.h:64: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kvm.h:387: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kvm.h:391: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/kvm.h:396: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/minix_fs.h:34: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/msdos_fs.h:100: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/neighbour.h:8: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nfs_idmap.h:55: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nubus.h:232: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nubus.h:296: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nubus.h:298: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/nubus.h:302: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/phonet.h:50: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/pkt_cls.h:122: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/pkt_cls.h:306: 
> leaks CONFIG_NET to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/pkt_cls.h:307: 
> leaks CONFIG_NET to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/pkt_sched.h:32: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/pktcdvd.h:36: leaks 
> CONFIG_CDROM to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/ppp_defs.h:50: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/random.h:39: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/raw.h:16: leaks 
> CONFIG_MAX to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:64: 
> leaks CONFIG_REISERFS to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:81: 
> leaks CONFIG_REISERFS to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:687: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:995: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:997: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1467: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1587: 
> leaks CONFIG_QUOTA to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1760: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1764: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1766: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1769: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1771: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1805: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1908: 
> leaks CONFIG_PROC to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1948: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1949: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1950: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1951: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1962: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1963: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/reiserfs_fs.h:1964: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/rtnetlink.h:328: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/signalfd.h:19: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/socket.h:27: leaks 
> CONFIG_PROC to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/socket.h:29: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/socket.h:262: leaks 
> CONFIG_COMPAT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:33: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:34: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:35: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:36: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:37: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:39: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:40: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:41: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/sound.h:42: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1047: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1048: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1049: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1050: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1051: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1053: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1055: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1056: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1061: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1062: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1078: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/soundcard.h:1079: 
> extern's make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/synclink.h:209: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/taskstats.h:44: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/types.h:114: leaks 
> CONFIG_LBD to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/video_decoder.h:7: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/video_encoder.h:5: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/videodev.h:18: 
> leaks CONFIG_VIDEO to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/videodev.h:53: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/videodev.h:313: 
> leaks CONFIG_VIDEO to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/videodev2.h:1477: 
> leaks CONFIG_VIDEO to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/virtio_blk.h:21: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/virtio_console.h:15: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/linux/virtio_net.h:28: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/boot.h:14: leaks 
> CONFIG_PHYSICAL to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/boot.h:15: leaks 
> CONFIG_PHYSICAL to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/boot.h:16: leaks 
> CONFIG_PHYSICAL to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/boot.h:18: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/e820.h:13: leaks 
> CONFIG_NODES to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/e820.h:27: leaks 
> CONFIG_EFI to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/e820.h:44: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/kvm.h:9: include of 
> <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/kvm.h:16: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/mce.h:7: include of 
> <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/mce.h:29: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/mtrr.h:61: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/prctl.h:9: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/prctl.h:10: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/prctl.h:11: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/ptrace-abi.h:83: 
> leaks CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/ptrace-abi.h:86: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/ptrace-abi.h:93: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/ptrace-abi.h:143: 
> leaks CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:15: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:16: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:17: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:23: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:24: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:51: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:52: extern's 
> make no sense in userspace

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/setup.h:54: leaks 
> CONFIG_PARAVIRT to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/sigcontext.h:5: 
> include of <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/sigcontext.h:24: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/sigcontext32.h:20: 
> found __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/swab.h:4: include of 
> <linux/types.h> is preferred over <asm/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/swab.h:7: found 
> __[us]{8,16,32,64} type without #include <linux/types.h>

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/swab.h:10: leaks 
> CONFIG_X86 to userspace where it is not valid

> /var/tmp/kernel/linux-2.6.29-rc2/usr/include/asm/swab.h:40: leaks 
> CONFIG_X86 to userspace where it is not valid
I found this patches series in LKML for some of these warnings :
http://lkml.org/lkml/2008/11/28/206

but they seem not ready to be pulled in mainline.



Regards.


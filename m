Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZL3BMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZL3BMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZL3BMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:12:40 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:41329 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZL3BMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:12:38 -0500
Date: Tue, 29 Dec 2009 20:12:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] global "unifdef-y" -> "header-y" under include/
Message-ID: <alpine.LFD.2.00.0912292007380.6968@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"unifdef-y" has been deprecated for quite some time in favour of
"header-y", straight substitution under entire include/ directory.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index eb62334..ae27333 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -29,7 +29,7 @@ header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h

-unifdef-y += int-l64.h
-unifdef-y += int-ll64.h
-unifdef-y += resource.h
-unifdef-y += siginfo.h
+header-y += int-l64.h
+header-y += int-ll64.h
+header-y += resource.h
+header-y += siginfo.h
diff --git a/include/drm/Kbuild b/include/drm/Kbuild
index bd3a1c2..40a224d 100644
--- a/include/drm/Kbuild
+++ b/include/drm/Kbuild
@@ -1,12 +1,12 @@
-unifdef-y += drm.h drm_sarea.h drm_mode.h
-unifdef-y += i810_drm.h
-unifdef-y += i830_drm.h
-unifdef-y += i915_drm.h
-unifdef-y += mga_drm.h
-unifdef-y += r128_drm.h
-unifdef-y += radeon_drm.h
-unifdef-y += sis_drm.h
-unifdef-y += savage_drm.h
-unifdef-y += vmwgfx_drm.h
-unifdef-y += via_drm.h
-unifdef-y += nouveau_drm.h
+header-y += drm.h drm_sarea.h drm_mode.h
+header-y += i810_drm.h
+header-y += i830_drm.h
+header-y += i915_drm.h
+header-y += mga_drm.h
+header-y += r128_drm.h
+header-y += radeon_drm.h
+header-y += sis_drm.h
+header-y += savage_drm.h
+header-y += vmwgfx_drm.h
+header-y += via_drm.h
+header-y += nouveau_drm.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 756f831..4bfd8f4 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -167,220 +167,220 @@ header-y += veth.h
 header-y += videotext.h
 header-y += x25.h

-unifdef-y += acct.h
-unifdef-y += adb.h
-unifdef-y += adfs_fs.h
-unifdef-y += agpgart.h
+header-y += acct.h
+header-y += adb.h
+header-y += adfs_fs.h
+header-y += agpgart.h
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
       		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
-unifdef-y += a.out.h
+header-y += a.out.h
 endif
-unifdef-y += apm_bios.h
-unifdef-y += atalk.h
-unifdef-y += atmdev.h
-unifdef-y += atm.h
-unifdef-y += atm_tcp.h
-unifdef-y += audit.h
-unifdef-y += auto_fs.h
-unifdef-y += auxvec.h
-unifdef-y += binfmts.h
-unifdef-y += blktrace_api.h
-unifdef-y += capability.h
-unifdef-y += capi.h
-unifdef-y += cciss_ioctl.h
-unifdef-y += cdrom.h
-unifdef-y += cm4000_cs.h
-unifdef-y += cn_proc.h
-unifdef-y += coda.h
-unifdef-y += connector.h
-unifdef-y += cuda.h
-unifdef-y += cyclades.h
-unifdef-y += dccp.h
-unifdef-y += dlm.h
-unifdef-y += dlm_plock.h
-unifdef-y += edd.h
-unifdef-y += elf.h
-unifdef-y += elfcore.h
-unifdef-y += errno.h
-unifdef-y += errqueue.h
-unifdef-y += ethtool.h
-unifdef-y += eventpoll.h
-unifdef-y += signalfd.h
-unifdef-y += ext2_fs.h
-unifdef-y += fb.h
-unifdef-y += fcntl.h
-unifdef-y += filter.h
-unifdef-y += flat.h
-unifdef-y += futex.h
-unifdef-y += fs.h
-unifdef-y += gameport.h
-unifdef-y += generic_serial.h
-unifdef-y += hdlcdrv.h
-unifdef-y += hdlc.h
-unifdef-y += hdreg.h
-unifdef-y += hid.h
-unifdef-y += hiddev.h
-unifdef-y += hidraw.h
-unifdef-y += hpet.h
-unifdef-y += i2c.h
-unifdef-y += i2c-dev.h
-unifdef-y += icmp.h
-unifdef-y += icmpv6.h
-unifdef-y += if_addr.h
-unifdef-y += if_arp.h
-unifdef-y += if_bridge.h
-unifdef-y += if_ec.h
-unifdef-y += if_eql.h
-unifdef-y += if_ether.h
-unifdef-y += if_fddi.h
-unifdef-y += if_frad.h
-unifdef-y += if_ltalk.h
-unifdef-y += if_link.h
-unifdef-y += if_phonet.h
-unifdef-y += if_pppol2tp.h
-unifdef-y += if_pppox.h
-unifdef-y += if_tr.h
-unifdef-y += if_tunnel.h
-unifdef-y += if_vlan.h
-unifdef-y += igmp.h
-unifdef-y += inet_diag.h
-unifdef-y += in.h
-unifdef-y += in6.h
-unifdef-y += inotify.h
-unifdef-y += input.h
-unifdef-y += ip.h
-unifdef-y += ipc.h
-unifdef-y += ipmi.h
-unifdef-y += ipv6.h
-unifdef-y += ipv6_route.h
-unifdef-y += isdn.h
-unifdef-y += isdnif.h
-unifdef-y += isdn_divertif.h
-unifdef-y += isdn_ppp.h
-unifdef-y += ivtv.h
-unifdef-y += ivtvfb.h
-unifdef-y += joystick.h
-unifdef-y += kdev_t.h
-unifdef-y += kd.h
-unifdef-y += kernelcapi.h
-unifdef-y += kernel.h
-unifdef-y += keyboard.h
+header-y += apm_bios.h
+header-y += atalk.h
+header-y += atmdev.h
+header-y += atm.h
+header-y += atm_tcp.h
+header-y += audit.h
+header-y += auto_fs.h
+header-y += auxvec.h
+header-y += binfmts.h
+header-y += blktrace_api.h
+header-y += capability.h
+header-y += capi.h
+header-y += cciss_ioctl.h
+header-y += cdrom.h
+header-y += cm4000_cs.h
+header-y += cn_proc.h
+header-y += coda.h
+header-y += connector.h
+header-y += cuda.h
+header-y += cyclades.h
+header-y += dccp.h
+header-y += dlm.h
+header-y += dlm_plock.h
+header-y += edd.h
+header-y += elf.h
+header-y += elfcore.h
+header-y += errno.h
+header-y += errqueue.h
+header-y += ethtool.h
+header-y += eventpoll.h
+header-y += signalfd.h
+header-y += ext2_fs.h
+header-y += fb.h
+header-y += fcntl.h
+header-y += filter.h
+header-y += flat.h
+header-y += futex.h
+header-y += fs.h
+header-y += gameport.h
+header-y += generic_serial.h
+header-y += hdlcdrv.h
+header-y += hdlc.h
+header-y += hdreg.h
+header-y += hid.h
+header-y += hiddev.h
+header-y += hidraw.h
+header-y += hpet.h
+header-y += i2c.h
+header-y += i2c-dev.h
+header-y += icmp.h
+header-y += icmpv6.h
+header-y += if_addr.h
+header-y += if_arp.h
+header-y += if_bridge.h
+header-y += if_ec.h
+header-y += if_eql.h
+header-y += if_ether.h
+header-y += if_fddi.h
+header-y += if_frad.h
+header-y += if_ltalk.h
+header-y += if_link.h
+header-y += if_phonet.h
+header-y += if_pppol2tp.h
+header-y += if_pppox.h
+header-y += if_tr.h
+header-y += if_tunnel.h
+header-y += if_vlan.h
+header-y += igmp.h
+header-y += inet_diag.h
+header-y += in.h
+header-y += in6.h
+header-y += inotify.h
+header-y += input.h
+header-y += ip.h
+header-y += ipc.h
+header-y += ipmi.h
+header-y += ipv6.h
+header-y += ipv6_route.h
+header-y += isdn.h
+header-y += isdnif.h
+header-y += isdn_divertif.h
+header-y += isdn_ppp.h
+header-y += ivtv.h
+header-y += ivtvfb.h
+header-y += joystick.h
+header-y += kdev_t.h
+header-y += kd.h
+header-y += kernelcapi.h
+header-y += kernel.h
+header-y += keyboard.h
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
       		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
-unifdef-y += kvm.h
+header-y += kvm.h
 endif
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
-unifdef-y += kvm_para.h
+header-y += kvm_para.h
 endif
-unifdef-y += llc.h
-unifdef-y += loop.h
-unifdef-y += lp.h
-unifdef-y += mempolicy.h
-unifdef-y += mii.h
-unifdef-y += mman.h
-unifdef-y += mroute.h
-unifdef-y += mroute6.h
-unifdef-y += msdos_fs.h
-unifdef-y += msg.h
-unifdef-y += nbd.h
-unifdef-y += ncp_fs.h
-unifdef-y += ncp.h
-unifdef-y += ncp_mount.h
-unifdef-y += netdevice.h
-unifdef-y += netfilter_bridge.h
-unifdef-y += netfilter_decnet.h
-unifdef-y += netfilter.h
-unifdef-y += netfilter_ipv4.h
-unifdef-y += netfilter_ipv6.h
-unifdef-y += net.h
-unifdef-y += netlink.h
-unifdef-y += nfs3.h
-unifdef-y += nfs4.h
-unifdef-y += nfsacl.h
-unifdef-y += nfs_fs.h
-unifdef-y += nfs.h
-unifdef-y += nfs_idmap.h
-unifdef-y += n_r3964.h
-unifdef-y += nubus.h
-unifdef-y += nvram.h
-unifdef-y += oom.h
-unifdef-y += parport.h
-unifdef-y += patchkey.h
-unifdef-y += pci.h
-unifdef-y += personality.h
-unifdef-y += pktcdvd.h
-unifdef-y += pmu.h
-unifdef-y += poll.h
-unifdef-y += ppp_defs.h
-unifdef-y += ppp-comp.h
-unifdef-y += pps.h
-unifdef-y += ptrace.h
-unifdef-y += quota.h
-unifdef-y += random.h
-unifdef-y += rfkill.h
-unifdef-y += irqnr.h
-unifdef-y += reboot.h
-unifdef-y += reiserfs_fs.h
-unifdef-y += reiserfs_xattr.h
-unifdef-y += route.h
-unifdef-y += rtc.h
-unifdef-y += rtnetlink.h
-unifdef-y += scc.h
-unifdef-y += sched.h
-unifdef-y += screen_info.h
-unifdef-y += sdla.h
-unifdef-y += securebits.h
-unifdef-y += selinux_netlink.h
-unifdef-y += sem.h
-unifdef-y += serial_core.h
-unifdef-y += serial.h
-unifdef-y += serio.h
-unifdef-y += shm.h
-unifdef-y += signal.h
-unifdef-y += smb_fs.h
-unifdef-y += smb.h
-unifdef-y += smb_mount.h
-unifdef-y += socket.h
-unifdef-y += sonet.h
-unifdef-y += sonypi.h
-unifdef-y += soundcard.h
-unifdef-y += stat.h
-unifdef-y += stddef.h
-unifdef-y += string.h
-unifdef-y += swab.h
-unifdef-y += synclink.h
-unifdef-y += sysctl.h
-unifdef-y += tcp.h
-unifdef-y += time.h
-unifdef-y += timex.h
-unifdef-y += tty.h
-unifdef-y += types.h
-unifdef-y += udp.h
-unifdef-y += uinput.h
-unifdef-y += uio.h
-unifdef-y += unistd.h
-unifdef-y += usbdevice_fs.h
-unifdef-y += utsname.h
-unifdef-y += videodev2.h
-unifdef-y += videodev.h
-unifdef-y += virtio_config.h
-unifdef-y += virtio_ids.h
-unifdef-y += virtio_blk.h
-unifdef-y += virtio_net.h
-unifdef-y += virtio_9p.h
-unifdef-y += virtio_balloon.h
-unifdef-y += virtio_console.h
-unifdef-y += virtio_pci.h
-unifdef-y += virtio_ring.h
-unifdef-y += virtio_rng.h
-unifdef-y += vt.h
-unifdef-y += wait.h
-unifdef-y += wanrouter.h
-unifdef-y += watchdog.h
-unifdef-y += wireless.h
-unifdef-y += xattr.h
-unifdef-y += xfrm.h
+header-y += llc.h
+header-y += loop.h
+header-y += lp.h
+header-y += mempolicy.h
+header-y += mii.h
+header-y += mman.h
+header-y += mroute.h
+header-y += mroute6.h
+header-y += msdos_fs.h
+header-y += msg.h
+header-y += nbd.h
+header-y += ncp_fs.h
+header-y += ncp.h
+header-y += ncp_mount.h
+header-y += netdevice.h
+header-y += netfilter_bridge.h
+header-y += netfilter_decnet.h
+header-y += netfilter.h
+header-y += netfilter_ipv4.h
+header-y += netfilter_ipv6.h
+header-y += net.h
+header-y += netlink.h
+header-y += nfs3.h
+header-y += nfs4.h
+header-y += nfsacl.h
+header-y += nfs_fs.h
+header-y += nfs.h
+header-y += nfs_idmap.h
+header-y += n_r3964.h
+header-y += nubus.h
+header-y += nvram.h
+header-y += oom.h
+header-y += parport.h
+header-y += patchkey.h
+header-y += pci.h
+header-y += personality.h
+header-y += pktcdvd.h
+header-y += pmu.h
+header-y += poll.h
+header-y += ppp_defs.h
+header-y += ppp-comp.h
+header-y += pps.h
+header-y += ptrace.h
+header-y += quota.h
+header-y += random.h
+header-y += rfkill.h
+header-y += irqnr.h
+header-y += reboot.h
+header-y += reiserfs_fs.h
+header-y += reiserfs_xattr.h
+header-y += route.h
+header-y += rtc.h
+header-y += rtnetlink.h
+header-y += scc.h
+header-y += sched.h
+header-y += screen_info.h
+header-y += sdla.h
+header-y += securebits.h
+header-y += selinux_netlink.h
+header-y += sem.h
+header-y += serial_core.h
+header-y += serial.h
+header-y += serio.h
+header-y += shm.h
+header-y += signal.h
+header-y += smb_fs.h
+header-y += smb.h
+header-y += smb_mount.h
+header-y += socket.h
+header-y += sonet.h
+header-y += sonypi.h
+header-y += soundcard.h
+header-y += stat.h
+header-y += stddef.h
+header-y += string.h
+header-y += swab.h
+header-y += synclink.h
+header-y += sysctl.h
+header-y += tcp.h
+header-y += time.h
+header-y += timex.h
+header-y += tty.h
+header-y += types.h
+header-y += udp.h
+header-y += uinput.h
+header-y += uio.h
+header-y += unistd.h
+header-y += usbdevice_fs.h
+header-y += utsname.h
+header-y += videodev2.h
+header-y += videodev.h
+header-y += virtio_config.h
+header-y += virtio_ids.h
+header-y += virtio_blk.h
+header-y += virtio_net.h
+header-y += virtio_9p.h
+header-y += virtio_balloon.h
+header-y += virtio_console.h
+header-y += virtio_pci.h
+header-y += virtio_ring.h
+header-y += virtio_rng.h
+header-y += vt.h
+header-y += wait.h
+header-y += wanrouter.h
+header-y += watchdog.h
+header-y += wireless.h
+header-y += xattr.h
+header-y += xfrm.h

 objhdr-y += version.h
 header-y += wimax.h
diff --git a/include/linux/byteorder/Kbuild b/include/linux/byteorder/Kbuild
index 3843722..5896e34 100644
--- a/include/linux/byteorder/Kbuild
+++ b/include/linux/byteorder/Kbuild
@@ -1,2 +1,2 @@
-unifdef-y += big_endian.h
-unifdef-y += little_endian.h
+header-y += big_endian.h
+header-y += little_endian.h
diff --git a/include/linux/dvb/Kbuild b/include/linux/dvb/Kbuild
index d97b3a5..ae6f3f7 100644
--- a/include/linux/dvb/Kbuild
+++ b/include/linux/dvb/Kbuild
@@ -4,6 +4,6 @@ header-y += net.h
 header-y += osd.h
 header-y += version.h

-unifdef-y += audio.h
-unifdef-y += dmx.h
-unifdef-y += video.h
+header-y += audio.h
+header-y += dmx.h
+header-y += video.h
diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 2aea503..c14829c 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -49,11 +49,11 @@ header-y += xt_tcpudp.h
 header-y += xt_time.h
 header-y += xt_u32.h

-unifdef-y += nf_conntrack_common.h
-unifdef-y += nf_conntrack_ftp.h
-unifdef-y += nf_conntrack_tcp.h
-unifdef-y += nfnetlink.h
-unifdef-y += nfnetlink_compat.h
-unifdef-y += x_tables.h
-unifdef-y += xt_physdev.h
-unifdef-y += xt_policy.h
+header-y += nf_conntrack_common.h
+header-y += nf_conntrack_ftp.h
+header-y += nf_conntrack_tcp.h
+header-y += nfnetlink.h
+header-y += nfnetlink_compat.h
+header-y += x_tables.h
+header-y += xt_physdev.h
+header-y += xt_policy.h
diff --git a/include/linux/netfilter_arp/Kbuild b/include/linux/netfilter_arp/Kbuild
index 4f13dfc..0912492 100644
--- a/include/linux/netfilter_arp/Kbuild
+++ b/include/linux/netfilter_arp/Kbuild
@@ -1,3 +1,3 @@
 header-y += arpt_mangle.h

-unifdef-y += arp_tables.h
+header-y += arp_tables.h
diff --git a/include/linux/netfilter_bridge/Kbuild b/include/linux/netfilter_bridge/Kbuild
index 76ff4c4..a0dc53f 100644
--- a/include/linux/netfilter_bridge/Kbuild
+++ b/include/linux/netfilter_bridge/Kbuild
@@ -13,5 +13,5 @@ header-y += ebt_stp.h
 header-y += ebt_ulog.h
 header-y += ebt_vlan.h

-unifdef-y += ebtables.h
-unifdef-y += ebt_802_3.h
+header-y += ebtables.h
+header-y += ebt_802_3.h
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index 431b407..491be33 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -11,5 +11,5 @@ header-y += ipt_ecn.h
 header-y += ipt_realm.h
 header-y += ipt_ttl.h

-unifdef-y += ip_queue.h
-unifdef-y += ip_tables.h
+header-y += ip_queue.h
+header-y += ip_tables.h
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index e864eae..eee0555 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -9,4 +9,4 @@ header-y += ip6t_mh.h
 header-y += ip6t_opts.h
 header-y += ip6t_rt.h

-unifdef-y += ip6_tables.h
+header-y += ip6_tables.h
diff --git a/include/linux/nfsd/Kbuild b/include/linux/nfsd/Kbuild
index fc97204..55d1467 100644
--- a/include/linux/nfsd/Kbuild
+++ b/include/linux/nfsd/Kbuild
@@ -1,6 +1,6 @@
-unifdef-y += const.h
-unifdef-y += debug.h
-unifdef-y += export.h
-unifdef-y += nfsfh.h
-unifdef-y += stats.h
-unifdef-y += syscall.h
+header-y += const.h
+header-y += debug.h
+header-y += export.h
+header-y += nfsfh.h
+header-y += stats.h
+header-y += syscall.h
diff --git a/include/linux/sunrpc/Kbuild b/include/linux/sunrpc/Kbuild
index fb438f1..98df211 100644
--- a/include/linux/sunrpc/Kbuild
+++ b/include/linux/sunrpc/Kbuild
@@ -1 +1 @@
-unifdef-y += debug.h
+header-y += debug.h
diff --git a/include/sound/Kbuild b/include/sound/Kbuild
index e9dd936..f094f06 100644
--- a/include/sound/Kbuild
+++ b/include/sound/Kbuild
@@ -3,7 +3,7 @@ header-y += hdsp.h
 header-y += hdspm.h
 header-y += sfnt_info.h

-unifdef-y += asequencer.h
-unifdef-y += asound.h
-unifdef-y += emu10k1.h
-unifdef-y += sb16_csp.h
+header-y += asequencer.h
+header-y += asound.h
+header-y += emu10k1.h
+header-y += sb16_csp.h
diff --git a/include/video/Kbuild b/include/video/Kbuild
index 0e406f7..2d988a2 100644
--- a/include/video/Kbuild
+++ b/include/video/Kbuild
@@ -1,2 +1,2 @@
-unifdef-y += sisfb.h uvesafb.h
-unifdef-y += edid.h
+header-y += sisfb.h uvesafb.h
+header-y += edid.h


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================

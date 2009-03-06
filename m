Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZCFE47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZCFE47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 23:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZCFE4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 23:56:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53181 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZCFE4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 23:56:47 -0500
Date: Fri, 6 Mar 2009 15:56:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: state of the trees
Message-Id: <20090306155634.cc6c682d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Mar_2009_15_56_34_+1100_+XPO8HqBry3xgVgU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Mar_2009_15_56_34_+1100_+XPO8HqBry3xgVgU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Given that the release of 2.6.29 and the new merge window is rapidly
approaching, I though I would see what sort of summary I could give of
what is currently in linux-next (and presumably what is destined for
2.6.30).

I have put up two files at
http://kernel.org/pub/linux/kernel/people/sfr/linux-next/next-20090305-{sum=
mary,diffstat}
(as well as compressed versions as they are a bit large for the mailing
lists.  I chose next-20090305 since it is the first release after
2.6.29-rc7.

The summary from the diffstat looks like this:

 4711 files changed, 646856 insertions(+, 216616 deletions(-)

Below is a summary of the state of each tree - the numbers following the
name are the total number of outstanding commits (relative to all the
preceding trees) and the number after doing "git patch-id" matching with
Linus' tree and all the previous trees.  Thus the order of the trees
makes a difference to the numbers.  No numbers means the tree is empty
relative to all the preceding trees.

The numbers for the kvm tree may be skewed a bit due to the way the tree
is maintained and its patches are sent to Linus.

The v4l-dvb tree is not reflected in the diffstat file above since it
was dropped because of build failures.

origin					(Linus' tree)
(These are just outstanding fixes for 2.6.29)
arm-current
m68k-current
powerpc-merge
sparc-current
scsi-rc-fixes
net-current
sound-current
pci-current
wireless-current	2	2
kbuild-current
driver-core.current
usb.current
cpufreq-current
input-current
md-current
audit-current
crypto-current
dwmw2
(From here on down are 2.6.30 candidate changes)
arm			65	65
avr32			2	2
blackfin
cris
ia64
m68k			6	6
m68knommu		33	33
mips
parisc
powerpc			95	94
4xx
galak			5	4
pxa			42	31
s390			49	49
sh			36	36
sparc
x86			513	505
xtensa
driver-core		52	49
usb			66	65
tip-core		42	42
cpus4096		3	3
tracing			179	169
genirq			17	17
safe-poison-pointers	4	4
sched			19	19
stackprotector
timers			5	3
pci			34	33
device-mapper		5	5
hid			9	9
i2c			15	15
jdelvare-hwmon		11	11
kernel-doc		1	1
v4l-dvb			368	367
quota			28	27
jfs			5	5
kbuild
ide			160	160
libata			19	19
nfs			43	43
xfs			41	24
infiniband		25	25
acpi			65	65
nfsd			28	27
ieee1394		112	94
ubi			1	1
kvm			1727	519
dlm			7	7
scsi			48	48
ocfs2			29	20
ext4			22	22
async_tx		15	15
udf			11	11
net			1239	1234
wireless		23	23
mtd
crypto			20	20
vfs
sound			315	314
cpufreq			34	34
v9fs			1	0
rr			101	100
cifs			10	10
mmc			3	1
gfs2			16	16
input			13	13
bkl-removal		4	4
ubifs			2	2
lsm
block
embedded
firmware		8	7
pcmcia
battery			3	3
leds			10	10
backlight		5	5
kgdb			1	1
slab			14	13
uclinux
md			23	23
mfd			21	10
hdlc
drm			34	34
voltage			42	23
security-testing	68	68
lblnet			1	1
ttydev			6	5
agp
kmemcheck		56	56
generic-ipi
oprofile
fastboot
sparseirq
iommu			34	34
uwb
watchdog		17	16
proc			11	11
bdev
dwmw2-iommu
cputime
osd			24	8
fatfs
fuse
jc_docs			1	1
nommu
trivial			23	22
audit
squashfs
omap			23	23
aoe
kmemleak		14	14
staging			403	403
scsi-post-merge

--=20
Cheers,
Stephen	Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Mar_2009_15_56_34_+1100_+XPO8HqBry3xgVgU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmwrQIACgkQjjKRsyhoI8yT0QCeLloE+vSzxWV5xn7jvvywjXST
H/MAn3GGoPFA27zcJWH7w5KK7gjllsq8
=PYuK
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Mar_2009_15_56_34_+1100_+XPO8HqBry3xgVgU--

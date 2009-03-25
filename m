Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZCYIft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZCYIft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCYIfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:35:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36108 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZCYIf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:35:26 -0400
Date: Wed, 25 Mar 2009 19:35:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org
Subject: linux-next: some stats
Message-Id: <20090325193517.b5b3b324.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Mar_2009_19_35_17_+1100_mvTWlynROv9IU=IN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Mar_2009_19_35_17_+1100_mvTWlynROv9IU=IN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

With the merge window opening, I though people might like to see some
figures from the linux-next tree (or not :-)).

"git diff -C" summaries:

[As a comparison, the equivalent for v2.6.28..v2.6.29-rc1 was
 8487 files changed, 970279 insertions(+), 237481 deletions(-)]

next-20090305 (just after -rc7):
 4670 files changed, 563138 insertions(+), 207605 deletions(-)
[staging tree contribution:
 886 files changed, 268746 insertions(+), 56558 deletions(-)]

next-20090316 (just after -rc8):
 5840 files changed, 673579 insertions(+), 265602 deletions(-)
[staging tree contribution:
 1010 files changed, 270367 insertions(+), 61819 deletions(-)]

next-20090324 (just after 2.6.29):
 6601 files changed, 711689 insertions(+), 295978 deletions(-)
[staging tree contribution:
 1059 files changed, 246467 insertions(+), 73673 deletions(-)]

Commit number summaries:
[This is non-merge commits per tree relative to all the preceding trees
(and Linus' tree).  I also don't count commits for which "git patch-id"
matches.  Even so, the first column of numbers is high for some trees due
to the way they have submitted to Linus' tree in the past.

I have left out the "current" trees that only contain bug fixes for the
current release.]

Tree              commits in   change since    change since
               next-20090324   next-20090316   next-20090305
                                 (-rc8)          (-rc7)

arm                      274       +118            +209
avr32                      2         +0              +0
blackfin                   0         +0              +0
cris                       0         +0              +0
ia64                       5         +5              +5
m68k                       6         +0              +0
m68knommu                 35         -7              +2
mips                       0         +0              +0
parisc                     0         +0              +0
powerpc                  144        +28             +50
4xx                        0         +0              +0
galak                      0         -3              -4
pxa                       28        +16              -3
s390                      66         +4             +17
sh                        96        +30             +60
sparc                      0         +0              +0
x86                      870       +115            +365
xtensa                     0         +0              +0
tip-core                 124        +23             +82
cpus4096                  37        +33             +34
tracing                  324        +90            +155
genirq                    30        +10             +13
safe-poison-pointers       4         +0              +0
sched                     32         +7             +13
stackprotector             0         +0              +0
timers                    23         +0             +20
pci                       40         +6              +6
device-mapper             22        +14             +17
hid                       14         +2              +5
i2c                       18         +2              +3
jdelvare-hwmon            11         +0              +0
kernel-doc                 1         +0              +0
v4l-dvb                  579        +84            +211
quota                     27         +0              +0
jfs                        5         +0              +0
kbuild                     0         +0              +0
ide                      177        +12             +17
libata                    19         +0              +0
nfs                       79         +0             +36
xfs                       32         +7              +8
infiniband                29         +0              +4
acpi                      55        -10             -10
nfsd                      38         +6             +11
ieee1394                 109         +9             +15
ubi                        1         +0              +0
kvm                      548        +12             +29
dlm                        7         +0              +0
scsi                     119         +2             +71
ocfs2                     33         +0             +13
ext4                      26         -1              +4
async_tx                   0         -2             -14
udf                       15         +1              +4
net                     1648       +248            +412
wireless                  85        +19             +62
mtd                       27        +27             +27
crypto                    29         +2              +9
vfs                        0         +0              +0
sound                    448        +40            +134
cpufreq                   35         +0              +1
v9fs                       0         +0              +0
rr                       102         +4              +2
cifs                      12         +2              +2
mmc                       40        +30             +38
gfs2                      18         +0              +2
input                     21         +0              +8
bkl-removal                4         +0              +0
ubifs                     12         +6             +10
lsm                        0         +0              +0
block                      7         -1              +7
embedded                   0         +0              +0
firmware                   7         +0              +0
pcmcia                     0         +0              +0
battery                    3         +0              +0
leds                      10         +0              +0
backlight                  5         +0              +0
kgdb                       4         +0              +3
slab                      15         +2              +2
uclinux                    0         +0              +0
md                        37        -20             +14
mfd                       12         +1              +2
hdlc                       0         +0              +0
drm                       45         +1             +11
voltage                   31         +3              +8
security-testing          71         +0              +3
lblnet                     5         +0              +4
ttydev                    28         +7             +23
agp                        0         +0              +0
generic-ipi                0         +0              +0
oprofile                   0         +0              +0
fastboot                   0         +0              +0
sparseirq                  1         +1              +1
iommu                     22        +20             -12
uwb                        0         +0              +0
watchdog                  18         +7              +2
proc                      12         +1              +1
bdev                       0         +0              +0
dwmw2-iommu                0         +0              +0
cputime                    0         +0              +0
osd                        8         +0              +0
fatfs                      0         +0              +0
fuse                       0         +0              +0
jc_docs                    1         +0              +0
nommu                      0         +0              +0
trivial                   27         +4              +5
audit                      0         +0              +0
squashfs                   0         +0              +0
omap                      35         +7             +12
aoe                        0         +0              +0
kmemleak                  14         +0              +0
suspend                   11         +1             +11
driver-core               53         +3              +9
usb                       92        +11             +27
staging                  705       +284            +302
scsi-post-merge            0         +0              +0

Totals                  7864      +1323           +2590

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Mar_2009_19_35_17_+1100_mvTWlynROv9IU=IN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknJ7MYACgkQjjKRsyhoI8xzhgCdE+ueJgBBafIxqAACJFXQCFJG
uFoAn2BBIUnAsR4TyQ6WQvfAvNh37EN6
=lRYu
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Mar_2009_19_35_17_+1100_mvTWlynROv9IU=IN--

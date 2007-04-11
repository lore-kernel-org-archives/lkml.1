Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXDKISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXDKISA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXDKISA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:18:00 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:52264 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbXDKIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:17:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: multipart/signed;
	micalg=sha1;
	protocol="application/x-pkcs7-signature";
	boundary="=-1af1EtyxYzOOqWv+aPbV"
Content-class: urn:content-classes:message
Subject: rsdl:mouse freezing while doing git-gc
Date: Wed, 11 Apr 2007 13:47:40 +0530
Message-ID: <1176279462.8833.8.camel@bluegenie>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: rsdl:mouse freezing while doing git-gc
Thread-Index: Acd8Eec+9x+r7g45SqSXGxLL7SqIqg==
From: <surya.prabhakar@wipro.com>
To: <kernel@kolivas.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Apr 2007 08:17:54.0713 (UTC) FILETIME=[E7B67090:01C77C11]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1af1EtyxYzOOqWv+aPbV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,
   I am using the kernel 2.6.21-rc4-rsdl. Machine is a P4 2.2 ghz with
512mb ram. While doing a git-gc with nice 19 , I am still seeing that my
mouse keeps freezing occasionally and other windows do not respond
immediately.

I have included the top output below.

kindly update me if any additional information is required.


top - 13:36:28 up 5 days,  1:33,  0 users,  load average: 3.93, 3.83,
2.52
Tasks: 148 total,   2 running, 146 sleeping,   0 stopped,   0 zombie
Cpu(s):  3.7%us,  0.5%sy,  0.2%ni, 93.2%id,  2.3%wa,  0.1%hi,  0.0%si,
0.0%st
Mem:    506388k total,   501252k used,     5136k free,     1412k buffers
Swap:   522104k total,   381880k used,   140224k free,   204744k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND                                                        =20
12367 surya      0  19  309m 213m 151m D 29.6 43.2   0:56.94
git-pack-object                                                =20
 2844 surya      0   0  113m  12m 4796 S  2.0  2.5   1:25.88
gnome-terminal                                                 =20
    1 root       0   0  2032  328  304 S  0.0  0.1   0:00.77
init                                                           =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
migration/0                                                    =20
    3 root       0  19     0    0    0 S  0.0  0.0   0:00.13
ksoftirqd/0                                                    =20
    4 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
watchdog/0                                                     =20
    5 root       1   0     0    0    0 S  0.0  0.0   0:00.88
events/0                                                       =20
    6 root       1   0     0    0    0 S  0.0  0.0   0:00.00
khelper                                                        =20
    7 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kthread                                                        =20
   46 root       0   0     0    0    0 S  0.0  0.0   0:00.43
kblockd/0                                                      =20
   47 root       5   0     0    0    0 S  0.0  0.0   0:00.00
kacpid                                                         =20
  125 root       5   0     0    0    0 S  0.0  0.0   0:00.00
cqueue/0                                                       =20
  126 root       5   0     0    0    0 S  0.0  0.0   0:00.00
ksuspend_usbd                                                  =20
  129 root       0   0     0    0    0 S  0.0  0.0   0:00.00
khubd                                                          =20
  131 root       0   0     0    0    0 S  0.0  0.0   0:00.04
kseriod                                                        =20
  153 root       0   0     0    0    0 D  0.0  0.0   0:13.49
kswapd0                                                        =20
  154 root       7   0     0    0    0 S  0.0  0.0   0:00.00
aio/0                                                          =20
  319 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kpsmoused                                                      =20
  335 root       0   0     0    0    0 S  0.0  0.0   0:10.71
kjournald                                                      =20
  356 root      13   0     0    0    0 S  0.0  0.0   0:00.00
kauditd                                                        =20
  382 root       0  -4  2412  232  232 S  0.0  0.0   0:00.18
udevd                                                          =20
  997 surya      0   0 31228 2020 1208 S  0.0  0.4   0:01.89
spamd                                                          =20
 1005 surya      0   0 37436 2220 1052 S  0.0  0.4   0:58.75
spamd                                                          =20
 1351 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kmpathd/0                                                      =20
 1357 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kmirrord                                                       =20
 1444 root       1   0     0    0    0 S  0.0  0.0   0:01.43
kjournald                                                      =20
 1446 root       0 -20     0    0    0 S  0.0  0.0   0:00.00
loop0                                                          =20
 1826 root       0   0  1688  352  312 S  0.0  0.1   0:00.42
syslogd                                                        =20
 1829 root       1   0  1640  228  228 S  0.0  0.0   0:00.01
klogd                                                          =20
 1854 rpc        1   0  1772  228  228 S  0.0  0.0   0:00.00
portmap                                                        =20
 1874 root       1   0  1788  308  308 S  0.0  0.1   0:00.00
rpc.statd                                                      =20
 1898 root       0   0  4928  220  196 S  0.0  0.0   0:00.03
rpc.idmapd                                                     =20
 1912 dbus       1   0  3276  824  652 S  0.0  0.2   3:12.65
dbus-daemon                                                    =20
 1921 root       1   0  2348  344  344 S  0.0  0.1   0:00.00
hcid                                                           =20
 1927 root       1   0  1712  260  260 S  0.0  0.1   0:00.00
sdpd                                                           =20
 1949 root       0 -10     0    0    0 S  0.0  0.0   0:00.00
krfcommd                                                       =20
 1981 root       0   0     0    0    0 S  0.0  0.0   0:00.00
rpciod/0                                                       =20
 1982 root       1   0     0    0    0 S  0.0  0.0   0:00.00
lockd                                                          =20
 1987 surya      0   0 35144 1140  996 S  0.0  0.2   0:20.81
spamd                                                          =20
 1999 root       1   0  1876  244  244 S  0.0  0.0   0:00.00
hidd                                                           =20
 2012 root       0   0  5056  240  240 S  0.0  0.0   0:00.00
hpiod                                                          =20
 2017 root       0   0 12712  836  540 S  0.0  0.2   0:00.17
python                                                         =20
 2036 root       1   0  5168  260  260 S  0.0  0.1   0:00.00
sshd                                                           =20
 2046 root       1   0  2668  292  292 S  0.0  0.1   0:00.00
xinetd                                                         =20
 2058 ntp        0   0  4300 4300 3296 S  0.0  0.8   0:00.29
ntpd                                                           =20
 2086 root       1   0  3900  120  120 S  0.0  0.0   0:00.00
rpc.rquotad                                                    =20
 2089 root      21   0     0    0    0 S  0.0  0.0   0:00.00
nfsd4                                                          =20
 2090 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2091 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2092 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2093 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2094 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2095 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2096 root       0   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2097 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd                                                           =20
 2100 root       0   0  1844  336  336 S  0.0  0.1   0:00.00
rpc.mountd                                                     =20
 2143 netdump    0   0  1844   92   92 S  0.0  0.0   0:00.00
netdump-server                                                 =20
 2152 root       0   0  1868  276  264 S  0.0  0.1   0:00.11
gpm                                                            =20
 2162 root       0   0 10324  592  568 S  0.0  0.1   0:00.14
httpd                                                          =20
 2177 root       0   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2179 root       0   0  1796  288  288 S  0.0  0.1   0:00.00
nasd                                                           =20
 2188 root       1   0  5216  560  504 S  0.0  0.1   0:00.10
crond                                                          =20
 2195 root       1   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2219 xfs        1   0  3964  712  660 S  0.0  0.1   0:00.53
xfs                                                            =20
 2238 avahi      0   0  2860  836  836 S  0.0  0.2   0:00.04
avahi-daemon                                                   =20
 2239 avahi      1   0  2860  132  128 S  0.0  0.0   0:00.00
avahi-daemon                                                   =20
 2248 haldaemo   1   0  6084 1724 1368 S  0.0  0.3   0:30.81
hald                                                           =20
 2249 root       1   0  3340  800  796 S  0.0  0.2   0:00.03
hald-runner                                                    =20
 2255 haldaemo   1   0  2292  560  560 S  0.0  0.1   0:00.00
hald-addon-acpi                                                =20
 2262 haldaemo   1   0  2288  600  576 S  0.0  0.1   0:00.83
hald-addon-keyb                                                =20
 2270 haldaemo   1   0  2288  572  572 S  0.0  0.1   0:00.00
hald-addon-keyb                                                =20
 2273 haldaemo   3   0  2288  572  572 S  0.0  0.1   0:00.00
hald-addon-keyb                                                =20
 2302 root       1   0  1628  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2303 root       3   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2324 root       3   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2325 root       3   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty                                                       =20
 2326 root       5   0  4488  648  648 S  0.0  0.1   0:00.00
prefdm                                                         =20
 2366 root       1   0 15072 1204 1204 S  0.0  0.2   0:00.05
gdm-binary                                                     =20
 2400 root       1   0 15400 1072 1072 S  0.0  0.2   0:00.05
gdm-binary                                                     =20
 2402 root       0   0  241m  19m 5756 S  0.0  3.9  31:30.10
Xorg                                                           =20
 2442 surya      1   0 22612 2336 2312 S  0.0  0.5   0:00.44
gnome-session                                                  =20
 2492 surya      0   0  4292  256  224 S  0.0  0.1   0:00.02
ssh-agent                                                      =20
 2495 surya      1   0  2812  360  360 S  0.0  0.1   0:00.00
dbus-launch                                                    =20
 2496 surya      1   0  3140  972  852 S  0.0  0.2   0:05.53
dbus-daemon                                                    =20
 2498 surya      1   0  7376 2128 1344 S  0.0  0.4   0:10.15
gconfd-2                                                       =20
 2501 surya      1   0  2536  480  480 S  0.0  0.1   0:00.00
gnome-keyring-d                                                =20
 2503 surya      1   0 31536 3288 2900 S  0.0  0.6   0:26.96
gnome-settings-                                                =20
 2520 surya      1   0 17960 5604 4500 S  0.0  1.1   2:01.58
metacity                                                       =20
 2524 surya      1   0 81148 7928 5204 S  0.0  1.6   1:57.77
gnome-panel                                                    =20
 2526 surya      0   0  121m 7508 5880 S  0.0  1.5   0:18.40
nautilus                                                       =20
 2529 surya      0   0 75420 2868 2396 S  0.0  0.6   0:46.94
gnome-power-man                                                =20
 2530 surya      1   0 22360 2172 2016 S  0.0  0.4   0:00.05
gnome-volume-ma                                                =20
 2532 surya      1   0 41676 1244 1240 S  0.0  0.2   0:00.98
bonobo-activati                                                =20
 2534 surya      0   0 32176 2676 2408 S  0.0  0.5   0:00.06
eggcups                                                        =20
 2536 surya      1   0 15488 1636 1524 S  0.0  0.3   0:00.01
bluez-pin                                                      =20
 2538 surya      1   0 40692 1948 1948 S  0.0  0.4   0:00.56
gnome-vfs-daemo                                                =20
 2556 surya      0   0 82980 3068 2128 S  0.0  0.6   0:03.35
beagled                                                        =20
 2559 surya      0   0 75596 3100 2688 S  0.0  0.6   0:00.92
nm-applet                                                      =20
 2566 surya      1   0 14900 2344 2080 S  0.0  0.5   0:00.44
pam-panel-icon                                                 =20
 2567 root       0   0  1812  556  504 S  0.0  0.1   0:00.07
pam_timestamp_c                                                =20
 2571 surya      1   0  5616  608  608 S  0.0  0.1   0:00.00
escd                                                           =20
 2590 surya      0   0 22804 2860 2600 S  0.0  0.6   0:15.23
notification-ar                                                =20
 2592 surya      0   0 24116 3836 3448 S  0.0  0.8   0:07.85
multiload-apple                                                =20
 2596 surya      0   0  2444  676  640 S  0.0  0.1   0:00.02
mapping-daemon                                                 =20
 2604 surya      0   0  114m 4808 3896 S  0.0  0.9   0:01.21
clock-applet                                                   =20
 2605 surya      0   0 78152 3636 3280 S  0.0  0.7   0:03.00
mixer_applet2                                                  =20
 2613 surya      0   0  2648  988  832 S  0.0  0.2   0:00.38
gam_server                                                     =20
 2615 surya      0   0  4440  572  572 S  0.0  0.1   0:00.00
firefox                                                        =20
 2626 surya      1   0  4440  564  564 S  0.0  0.1   0:00.00
run-mozilla.sh                                                 =20
 2631 surya      0   0  247m  55m  12m S  0.0 11.2  23:51.29
firefox-bin                                                    =20
 2647 surya      1   0 16140 3068 2708 S  0.0  0.6   0:22.29
gnome-screensav                                                =20
 2847 surya      0   0  2440  524  524 S  0.0  0.1   0:00.01
gnome-pty-helpe                                                =20
 2848 surya      1   0  4624  804  780 S  0.0  0.2   0:00.88
bash                                                           =20
 2982 surya      1   0 79352 9984 3168 S  0.0  2.0   0:36.65
kscope                                                         =20
 2984 surya      1   0 29240 1028  944 S  0.0  0.2   0:00.07
kdeinit                                                        =20
 2987 surya      1   0 17244  708  708 S  0.0  0.1   0:00.01
dcopserver                                                     =20
 2989 surya      0   0 29908 1336 1156 S  0.0  0.3   0:00.03
klauncher                                                      =20
 2991 surya      0   0 29860 1820 1572 S  0.0  0.4   0:00.52
kded                                                           =20
 2996 surya      1   0 37108 2044 1712 R  0.0  0.4   0:02.26
knotify                                                        =20
 3013 surya      1   0 29356 1040  956 S  0.0  0.2   0:00.00
kio_file                                                       =20
 3754 surya      0   0 31216 1976 1148 D  0.0  0.4   0:02.96
spamd                                                          =20
 5235 surya      0   0  112m 7100 4700 S  0.0  1.4   0:21.22
gedit                                                          =20
 7879 root       0   0  9948 1060  916 S  0.0  0.2   0:00.09
cupsd                                                          =20
 7907 apache     0   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7908 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7909 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7910 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7911 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7912 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7913 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 7914 apache     1   0 10324  352  348 S  0.0  0.1   0:00.00
httpd                                                          =20
 8823 surya      0   0  100m  15m 4056 S  0.0  3.1   1:41.49
evolution-excha                                                =20
 8827 surya      1   0 70272 2980 2236 S  0.0  0.6   0:00.17
evolution-data-                                                =20
 8833 surya      1   0  317m  24m 8888 S  0.0  5.1   5:03.74
evolution                                                      =20
 8868 surya      0   0 71032 4300 3912 S  0.0  0.8   0:00.20
evolution-alarm                                                =20
 8939 surya      0   0 31228 3856 1296 S  0.0  0.8   0:02.23
spamd                                                          =20
10904 surya      0   0 36480 9952 1660 S  0.0  2.0   1:15.14
spamd                                                          =20
11872 surya      1   0 23212 2848 2844 S  0.0  0.6   0:00.03
gpilotd                                                        =20
12354 surya     20  19  3684  484  484 S  0.0  0.1   0:00.00
git-gc                                                         =20
12357 surya     20  19  4440  684  684 S  0.0  0.1   0:00.06
git-repack                                                     =20
12366 surya     20  19  4440  228  228 S  0.0  0.0   0:00.00
git-repack                                                     =20
12432 root       0   0     0    0    0 S  0.0  0.0   0:00.01
pdflush                                                        =20
12434 root       1   0     0    0    0 S  0.0  0.0   0:00.00
pdflush                                                        =20
12444 surya      0   0  2164  956  724 R  0.0  0.2   0:00.00
top                                                            =20
20886 surya      1   0  4620  664  664 S  0.0  0.1   0:00.05
bash                                                           =20
28252 surya      0   0 11580 1204  932 S  0.0  0.2   0:08.20
artsd                                                          =20
28753 surya      0   0  4620 1236 1060 S  0.0  0.2   0:00.33
bash                                                           =20
31644 surya      1   0 79580 6644 4532 S  0.0  1.3   0:37.31
wnck-applet                                                    =20


--=20
surya.
11/04/2007

--=-1af1EtyxYzOOqWv+aPbV
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJIzCCAuww
ggJVoAMCAQICEG8zftGmvYfSeKA1FishBukwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDMyMjExNTExNloXDTA4MDMyMTExNTEx
NlowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc3Vy
eWEucHJhYmhha2FyQHdpcHJvLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN/+
l9Kx40VowHNy1cV5enxc1UE6Dw52tCjR1fyyTrYXdb8Xir04OhwY+++irn6eIMFclcTVAHfTXgWR
rXgBmi1AcFPy2zhDwHOc9f4Kj+KMddJYKe5zSdh8KqRXgAr8MoZ1fBiq/KrKZq9vUzwCW3Q0nJDC
S8c3zG1GPQMmQZCYdoXiuFEmPOYqiNmu3gCJicTs9lgxB6j+5XiGcHrn8KHlHe3kqODpMHfVnxmk
Y/Z1A0NkDfFwbqNj/85zTAusk3ZLqvSRScR0F3AA132aZ1LA0tVG6a1u8Ki5cpQrgFvkF1eFqUiu
DMht+EUkzaW25I8Lbon1YCEko5DARpRhc9ECAwEAAaM2MDQwJAYDVR0RBB0wG4EZc3VyeWEucHJh
Ymhha2FyQHdpcHJvLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAAMG17rbLz6X
A1n8zcIjX8+oGrJIaOo2metS9rZ/muMfvz5tqhrrWGaFxbwjy6czu13wkryXnEHuzQ+P1RYi4MLe
ai6xAXzfjDIbJvUfbhp4gUxtDgJQa+QjS3BDwh55iG2KuBLa3yM6Z1ot4i6J4+rUcMSrlAaDx+e2
yEPbqp8gMIIC7DCCAlWgAwIBAgIQbzN+0aa9h9J4oDUWKyEG6TANBgkqhkiG9w0BAQUFADBiMQsw
CQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDcwMzIyMTE1MTE2WhcN
MDgwMzIxMTE1MTE2WjBLMR8wHQYDVQQDExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMSgwJgYJKoZI
hvcNAQkBFhlzdXJ5YS5wcmFiaGFrYXJAd2lwcm8uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEA3/6X0rHjRWjAc3LVxXl6fFzVQToPDna0KNHV/LJOthd1vxeKvTg6HBj776Kufp4g
wVyVxNUAd9NeBZGteAGaLUBwU/LbOEPAc5z1/gqP4ox10lgp7nNJ2HwqpFeACvwyhnV8GKr8qspm
r29TPAJbdDSckMJLxzfMbUY9AyZBkJh2heK4USY85iqI2a7eAImJxOz2WDEHqP7leIZweufwoeUd
7eSo4Okwd9WfGaRj9nUDQ2QN8XBuo2P/znNMC6yTdkuq9JFJxHQXcADXfZpnUsDS1UbprW7wqLly
lCuAW+QXV4WpSK4MyG34RSTNpbbkjwtuifVgISSjkMBGlGFz0QIDAQABozYwNDAkBgNVHREEHTAb
gRlzdXJ5YS5wcmFiaGFrYXJAd2lwcm8uY29tMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQAD
gYEAAwbXutsvPpcDWfzNwiNfz6gaskho6jaZ61L2tn+a4x+/Pm2qGutYZoXFvCPLpzO7XfCSvJec
Qe7ND4/VFiLgwt5qLrEBfN+MMhsm9R9uGniBTG0OAlBr5CNLcEPCHnmIbYq4EtrfIzpnWi3iLonj
6tRwxKuUBoPH57bIQ9uqnyAwggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYD
VQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNV
BAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERp
dmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0B
CQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2
MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8M
OmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsY
Pge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/
BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3Rl
UGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNV
BAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+v
rL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sn
cVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYID
EDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0
eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEG8z
ftGmvYfSeKA1FishBukwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDcwNDExMDgxNzMxWjAjBgkqhkiG9w0BCQQxFgQUug6eicv6hLVYQ5MM
DpOabMOEjv4wgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0
ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMA0G
CSqGSIb3DQEBAQUABIIBAIPYnfEq/S7UwNeXpK3SPOoOGJF7jnfUmOyccpNzmctiLuJFOPVXqSvt
Ozx2ZaAvb7GvFMff/rlMb6O3nJgCZj+j5uh59YBG2wRFeTEV+EQdoOKN5S3XVWNV74pLpQ9dLdDy
+pcAi6Nt7FoL/qoTtAC0Ve+YtA0BeaAG3fCrvKbocN+7sP8z37HceJqAc30pGjNHwh41mBrdPahi
qu2VEeXhujnY/pIS1UnTJnZjvfVuJMaY2kvhz0BUUo4Ep3Bvx+3oGYBgvrhKBX2EImF3SoQaeWaJ
6frFKxl7lgCf/z0gRKB1qAz1kea48/w3HlqdrQbp1lnCD4KQsR/3qs/efjsAAAAAAAA=


--=-1af1EtyxYzOOqWv+aPbV--

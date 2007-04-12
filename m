Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXDLHvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXDLHvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161572AbXDLHvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:51:14 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:59441 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161429AbXDLHvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:51:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: multipart/signed;
	micalg=sha1;
	protocol="application/x-pkcs7-signature";
	boundary="=-LVi8dz+az+wDiNfxEuwD"
Content-class: urn:content-classes:message
Subject: Re: rsdl:mouse freezing while doing git-gc
Date: Thu, 12 Apr 2007 13:21:02 +0530
Message-ID: <1176364262.2633.27.camel@bluegenie>
In-Reply-To: <b647ffbd0704110501x79b6dba7rf094113b59016559@mail.gmail.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: rsdl:mouse freezing while doing git-gc
Thread-Index: Acd811FgtWzAfVHAS0Ws9WvTM3cWjw==
References: <1176279462.8833.8.camel@bluegenie> <b647ffbd0704110501x79b6dba7rf094113b59016559@mail.gmail.com>
From: <surya.prabhakar@wipro.com>
To: <dmitry.adamushko@gmail.com>
Cc: <kernel@kolivas.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 07:51:03.0805 (UTC) FILETIME=[51F322D0:01C77CD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LVi8dz+az+wDiNfxEuwD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-11 at 14:01 +0200, Dmitry Adamushko wrote:
> On 11/04/07, surya.prabhakar@wipro.com <surya.prabhakar@wipro.com> wrote:
> > Hi,
> >    I am using the kernel 2.6.21-rc4-rsdl. Machine is a P4 2.2 ghz with
> > 512mb ram. While doing a git-gc with nice 19 , I am still seeing that m=
y
> > mouse keeps freezing occasionally and other windows do not respond
> > immediately.
> >
> > I have included the top output below.
> >
> > kindly update me if any additional information is required.
> >
>=20
> btw, it's sd-0.39, isn't?
No! it is not. I have updated it to 2.6.21-rc5-sd-0.39.patch   and=20
did the same tests.

Tried git-gc at different nice values ( 0,5,10)
below are the results...

at nice 0
top output:
--------------------
[surya@bluegenie tests]$ cat git-gc_nice0
top - 12:12:45 up  1:34,  0 users,  load average: 0.51, 0.83, 0.88
Tasks: 137 total,   2 running, 134 sleeping,   0 stopped,   1 zombie
Cpu(s): 27.1%us,  5.5%sy,  0.0%ni, 62.9%id,  4.3%wa,  0.2%hi,  0.1%si,
0.0%st
Mem:    506112k total,   500576k used,     5536k free,     7196k buffers
Swap:   522104k total,   147476k used,   374628k free,   238224k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND                                                        =20
 4261 surya      9   0  213m  80m  56m R 83.9 16.4   0:09.60
git-pack-object                                                =20
 3275 surya      1   0 39152 5636 3800 S  2.0  1.1   0:01.90
xmms                                                           =20
 4264 surya      7   0  2160  952  724 R  2.0  0.2   0:00.01
top                                                            =20
    1 root       3   0  2036  488  460 S  0.0  0.1   0:00.82
init                                                           =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
migration/0                                                    =20
    3 root      20  19     0    0    0 S  0.0  0.0   0:00.00
ksoftirqd/0                                                    =20
    4 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
watchdog/0                                                     =20
    5 root       3   0     0    0    0 S  0.0  0.0   0:00.06
events/0       =20

Mouse is causing trouble. It was moving slowly like dragging.Windows are
not refreshing immediately.Even the=20
charcters being typed in gnome-terminal are delayed by a sec as if like
some remote terminal


at nice 5
top output:
--------------------
[surya@bluegenie tests]$ cat git-gc_nice5
top - 12:18:27 up  1:40,  0 users,  load average: 0.57, 1.16, 1.09
Tasks: 137 total,   3 running, 133 sleeping,   0 stopped,   1 zombie
Cpu(s): 26.5%us,  5.4%sy,  0.2%ni, 61.6%id,  6.1%wa,  0.2%hi,  0.1%si,
0.0%st
Mem:    506112k total,   500380k used,     5732k free,    12060k buffers
Swap:   522104k total,   177884k used,   344220k free,   211228k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND                                                        =20
 4338 surya     12   5  224m 106m  72m R 68.7 21.6   0:14.43
git-pack-object                                                =20
 2695 surya      1   0 70316 7508 4248 R  9.8  1.5   0:08.85
evolution-excha                                                =20
 2633 surya      3   0  324m  21m 9824 S  3.9  4.4   0:53.20
evolution                                                      =20
 4340 surya      1   0  2164  948  724 R  2.0  0.2   0:00.01
top                                                            =20
    1 root       1   0  2036  488  460 S  0.0  0.1   0:00.82
init                                                           =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
migration/0                                                    =20
    3 root      20  19     0    0    0 S  0.0  0.0   0:00.00
ksoftirqd/0                                                    =20
    4 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
watchdog/0                                                     =20
    5 root       1   0     0    0    0 S  0.0  0.0   0:00.06
events/0                                                       =20
    6 root      13   0     0    0    0 S  0.0  0.0   0:00.00
khelper                                                        =20
    7 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kthread                                                        =20
   46 root       1   0     0    0    0 S  0.0  0.0   0:00.04
kblockd/0                                                      =20
   47 root      20   0     0    0    0 S  0.0  0.0   0:00.00
kacpid        =20

Mouse movement was lot smother but for less than a second it is=20
getting stuck occasionally and freeing itself. Windows are refreshing
in a little bit delayed mode but lot better than previous.=20


at nice 10
top output:
--------------------

[surya@bluegenie tests]$ cat git-gc_nice10
top - 12:21:41 up  1:43,  0 users,  load average: 1.99, 1.75, 1.34
Tasks: 136 total,   4 running, 131 sleeping,   0 stopped,   1 zombie
Cpu(s): 26.2%us,  5.3%sy,  0.9%ni, 60.1%id,  7.2%wa,  0.2%hi,  0.1%si,
0.0%st
Mem:    506112k total,   499692k used,     6420k free,     2180k buffers
Swap:   522104k total,   183572k used,   338532k free,   231208k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND                                                        =20
 4378 surya     25  10  262m 155m  90m R 98.5 31.4   0:20.64
git-pack-object                                                =20
 4381 surya      1   0  2160  952  724 R  2.0  0.2   0:00.01
top                                                            =20
    1 root       1   0  2036  488  460 S  0.0  0.1   0:00.82
init                                                           =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
migration/0                                                    =20
    3 root      20  19     0    0    0 S  0.0  0.0   0:00.00
ksoftirqd/0                                                    =20
    4 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
watchdog/0                                                     =20
    5 root       1   0     0    0    0 S  0.0  0.0   0:00.06
events/0                                                       =20
    6 root      13   0     0    0    0 S  0.0  0.0   0:00.00
khelper                                                        =20
    7 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kthread                                                        =20
   46 root       1   0     0    0    0 S  0.0  0.0   0:00.04
kblockd/0                                                      =20
   47 root      20   0     0    0    0 S  0.0  0.0   0:00.00
kacpid                                                         =20
  125 root      20   0     0    0    0 S  0.0  0.0   0:00.00
cqueue/0                                                       =20
  126 root      20   0     0    0    0 S  0.0  0.0   0:00.00
ksuspend_usbd                                                  =20
  129 root       1   0     0    0    0 S  0.0  0.0   0:00.00
khubd            =20

Mouse moverment was smoother with no disturbance. Window refreshing
was fine.

PRI values s constantly changing while the git-gc is running. Is this
expected behaviour?
Hum... according to Con's "priority matrix" table, a nice 19 task can
> run only one priority slot per major rotation and this slot is fixed
> (20). So I'd expect "top" showing the same value in "PR" for all the
> tasks with "NI" =3D=3D 19 and this is not a case in your case (see an
> excerpt from your output below).
>=20
> Either I'm still missing something important or there is something
> fishy here.. will try to look at the code a bit later.
>=20
> tasks with NI=3D=3D19 show different "PR"s
>=20
> >
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
> > COMMAND
> > 12367 surya      0  19  309m 213m 151m D 29.6 43.2   0:56.94
> > git-pack-object
> >     3 root       0  19     0    0    0 S  0.0  0.0   0:00.13
> > ksoftirqd/0
> > 12354 surya     20  19  3684  484  484 S  0.0  0.1   0:00.00
> > git-gc
> > 12357 surya     20  19  4440  684  684 S  0.0  0.1   0:00.06
> > git-repack
> > 12366 surya     20  19  4440  228  228 S  0.0  0.0   0:00.00
> > git-repack

Now I tried replicating the above scenario , to see the PRI values
for process with same nice values. The above seems like an anomaly.

Did another test with hackbench and git-gc both at same priorities=20
and captured the top output, in here all of them seem to have=20
same priority..

#nice -n 19 hackbench 30
#nice -n 19 git-gc
#top -n1 -b

top - 13:11:20 up  2:33,  0 users,  load average: 49.98, 19.84, 11.78
Tasks: 612 total,  31 running, 130 sleeping,   0 stopped, 451 zombie
Cpu(s): 19.2%us,  4.4%sy,  1.8%ni, 67.1%id,  7.3%wa,  0.2%hi,  0.1%si,
0.0%st
Mem:    506112k total,   293260k used,   212852k free,      364k buffers
Swap:   522104k total,   234528k used,   287576k free,   111368k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
COMMAND            =20
11158 surya     20  19  1480  292  244 R  1.5  0.1   0:00.11
hackbench          =20
12360 surya      9   0  2820 1632  724 R  0.9  0.3   0:00.12
top                =20
11157 surya     20  19  222m  98m  66m R  0.6 19.8   0:12.40
git-pack-object    =20
 2671 surya      1   0  261m 7096 5504 S  0.3  1.4   0:08.97
workrave           =20
11168 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11218 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11252 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11359 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11364 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11402 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11479 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11484 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11489 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11498 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11564 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11569 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11574 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11616 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11639 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11654 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11682 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11691 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11696 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11738 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11847 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11858 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11928 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11972 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11976 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
11999 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12046 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12054 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12075 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12133 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12167 surya     20  19  1480  144   96 R  0.3  0.0   0:00.01
hackbench          =20
12172 surya     20  19  1480  144   96 R  0.3  0.0   0:00.01
hackbench          =20
12177 surya     20  19  1480  144   96 R  0.3  0.0   0:00.01
hackbench          =20
12201 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12206 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12211 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
12216 surya     20  19     0    0    0 Z  0.3  0.0   0:00.01 hackbench
<defunct>=20
    1 root       1   0  2036  488  460 S  0.0  0.1   0:00.83
init               =20
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
migration/0        =20
    3 root      20  19     0    0    0 R  0.0  0.0   0:00.00
ksoftirqd/0        =20
    4 root      RT   0     0    0    0 S  0.0  0.0   0:00.00
watchdog/0         =20
    5 root       3   0     0    0    0 S  0.0  0.0   0:00.13
events/0           =20
    6 root      13   0     0    0    0 S  0.0  0.0   0:00.00
khelper            =20
    7 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kthread            =20
   46 root       1   0     0    0    0 S  0.0  0.0   0:00.06
kblockd/0          =20
   47 root      20   0     0    0    0 S  0.0  0.0   0:00.00
kacpid             =20
  125 root      20   0     0    0    0 S  0.0  0.0   0:00.00
cqueue/0           =20
  126 root      20   0     0    0    0 S  0.0  0.0   0:00.00
ksuspend_usbd      =20
  129 root       1   0     0    0    0 S  0.0  0.0   0:00.00
khubd              =20
  131 root       1   0     0    0    0 S  0.0  0.0   0:00.01
kseriod            =20
  150 root       1   0     0    0    0 S  0.0  0.0   0:00.22
pdflush            =20
  152 root       5   0     0    0    0 S  0.0  0.0   0:01.74
kswapd0            =20
  153 root      33   0     0    0    0 S  0.0  0.0   0:00.00
aio/0              =20
  318 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kpsmoused          =20
  334 root      17   0     0    0    0 S  0.0  0.0   0:00.57
kjournald          =20
  355 root      21   0     0    0    0 S  0.0  0.0   0:00.00
kauditd            =20
  381 root       0  -4  2408  320  320 S  0.0  0.1   0:00.14
udevd              =20
 1349 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kmpathd/0          =20
 1355 root       1   0     0    0    0 S  0.0  0.0   0:00.00
kmirrord           =20
 1443 root       5   0     0    0    0 S  0.0  0.0   0:00.00
kjournald          =20
 1445 root       0 -20     0    0    0 S  0.0  0.0   0:00.00
loop0              =20
 1840 root       3   0  1688  496  456 S  0.0  0.1   0:00.05
syslogd            =20
 1843 root       1   0  1640  316  316 S  0.0  0.1   0:00.03
klogd              =20
 1868 rpc       11   0  1772  368  368 S  0.0  0.1   0:00.00
portmap            =20
 1887 root      11   0  1784  460  460 S  0.0  0.1   0:00.01
rpc.statd          =20
 1912 root       3   0  4932  304  276 S  0.0  0.1   0:00.00
rpc.idmapd         =20
 1926 dbus       5   0  3272  824  660 S  0.0  0.2   0:03.92
dbus-daemon        =20
 1935 root       1   0  2348  432  432 S  0.0  0.1   0:00.00
hcid               =20
 1939 root       1   0  1712  352  352 S  0.0  0.1   0:00.00
sdpd               =20
 1961 root       1 -10     0    0    0 S  0.0  0.0   0:00.00
krfcommd           =20
 1993 root       1   0     0    0    0 S  0.0  0.0   0:00.12
rpciod/0           =20
 1994 root       1   0     0    0    0 S  0.0  0.0   0:00.00
lockd              =20
 2011 root       1   0  1872  332  332 S  0.0  0.1   0:00.00
hidd               =20
 2024 root       1   0  5052  248  248 S  0.0  0.0   0:00.00
hpiod              =20
 2029 root       1   0 12716  924  628 S  0.0  0.2   0:00.00
python             =20
 2039 root       1   0  9940  896  756 S  0.0  0.2   0:00.03
cupsd              =20
 2048 root       3   0  5172  348  348 S  0.0  0.1   0:00.00
sshd               =20
 2058 root       1   0  2672  452  452 S  0.0  0.1   0:00.00
xinetd             =20
 2070 ntp        3   0  4304 4304 3296 S  0.0  0.9   0:00.01
ntpd               =20
 2098 root      11   0  3900  120  120 S  0.0  0.0   0:00.00
rpc.rquotad        =20
 2101 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd4              =20
 2102 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2103 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2104 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2105 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2106 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2107 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2108 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2109 root       1   0     0    0    0 S  0.0  0.0   0:00.00
nfsd               =20
 2112 root       9   0  1836  128  128 S  0.0  0.0   0:00.00
rpc.mountd         =20
 2155 netdump    1   0  1840  128  128 S  0.0  0.0   0:00.00
netdump-server     =20
 2164 root       3   0  1868  276  264 S  0.0  0.1   0:00.00
gpm                =20
 2173 root       1   0  1800  288  288 S  0.0  0.1   0:00.00
nasd               =20
 2182 root       1   0  5220  564  504 S  0.0  0.1   0:00.01
crond              =20
 2213 xfs        1   0  3964  656  604 S  0.0  0.1   0:00.12
xfs                =20
 2232 avahi      1   0  2860  660  660 S  0.0  0.1   0:00.03
avahi-daemon       =20
 2233 avahi      1   0  2860  128  128 S  0.0  0.0   0:00.00
avahi-daemon       =20
 2242 haldaemo   1   0  6088 1736 1400 S  0.0  0.3   0:02.57
hald               =20
 2243 root       1   0  3336  636  636 S  0.0  0.1   0:00.03
hald-runner        =20
 2249 haldaemo   1   0  2288  560  560 S  0.0  0.1   0:00.00
hald-addon-acpi    =20
 2256 haldaemo   1   0  2288  600  576 S  0.0  0.1   0:00.15
hald-addon-keyb    =20
 2264 haldaemo   9   0  2288  576  576 S  0.0  0.1   0:00.00
hald-addon-keyb    =20
 2267 haldaemo   9   0  2288  576  576 S  0.0  0.1   0:00.00
hald-addon-keyb    =20
 2294 root       1   0  1628  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2295 root       1   0  1628  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2296 root       1   0  1628  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2297 root       3   0  1628  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2298 root       1   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2299 root       3   0  1624  372  372 S  0.0  0.1   0:00.00
mingetty           =20
 2314 root       9   0  4488  648  648 S  0.0  0.1   0:00.00
prefdm             =20
 2360 root       1   0 15072 1360 1360 S  0.0  0.3   0:00.08
gdm-binary         =20
 2394 root       1   0 15400 1228 1192 S  0.0  0.2   0:00.03
gdm-binary         =20
 2398 root       3   0  229m  15m 5760 S  0.0  3.0   3:59.14
Xorg               =20
 2436 surya      1   0 22616 2728 2640 S  0.0  0.5   0:00.11
gnome-session      =20
 2486 surya      1   0  4288  260  224 S  0.0  0.1   0:00.00
ssh-agent          =20
 2489 surya      1   0  2816  380  380 S  0.0  0.1   0:00.00
dbus-launch        =20
 2490 surya      1   0  3140  892  892 S  0.0  0.2   0:00.28
dbus-daemon        =20
 2492 surya      1   0  7356 1920 1384 S  0.0  0.4   0:00.87
gconfd-2           =20
 2495 surya      1   0  2540  416  416 S  0.0  0.1   0:00.00
gnome-keyring-d    =20
 2497 surya      1   0 31532 3692 3268 S  0.0  0.7   0:03.53
gnome-settings-    =20
 2514 surya      1   0 17776 5568 4472 S  0.0  1.1   0:21.76
metacity           =20
 2517 surya      1   0 75412 3192 2772 S  0.0  0.6   0:01.64
gnome-power-man    =20
 2519 surya      1   0 80480 5736 4260 S  0.0  1.1   0:07.12
gnome-panel        =20
 2524 surya      1   0 22360 2396 2204 S  0.0  0.5   0:00.02
gnome-volume-ma    =20
 2526 surya     11   0 41548 1312 1312 S  0.0  0.3   0:00.23
bonobo-activati    =20
 2529 surya      1   0 40448 3296 3016 S  0.0  0.7   0:00.06
eggcups            =20
 2531 surya      1   0 15488 1780 1780 S  0.0  0.4   0:00.01
bluez-pin          =20
 2539 surya      1   0 11384 1524 1524 S  0.0  0.3   0:00.04
gnome-vfs-daemo    =20
 2549 surya      1   0 75596 3548 3180 S  0.0  0.7   0:00.17
nm-applet          =20
 2550 surya     19   0 88076 4400 2668 S  0.0  0.9   0:01.99
beagled            =20
 2555 surya      1   0 14904 2664 2408 S  0.0  0.5   0:00.04
pam-panel-icon     =20
 2557 root       1   0  1808  556  504 S  0.0  0.1   0:00.00
pam_timestamp_c    =20
 2561 surya     11   0  5616  688  688 S  0.0  0.1   0:00.01
escd               =20
 2583 surya      1   0 22804 3500 3076 S  0.0  0.7   0:00.48
notification-ar    =20
 2584 surya      1   0 79016 5956 4436 S  0.0  1.2   0:15.93
wnck-applet        =20
 2585 surya      1   0 22752 3656 3232 S  0.0  0.7   0:00.68
multiload-apple    =20
 2591 surya      1   0 27816 4240 3604 S  0.0  0.8   0:00.13
clock-applet       =20
 2593 surya      1   0  2440  708  672 S  0.0  0.1   0:00.00
mapping-daemon     =20
 2594 surya      1   0 78156 4256 3736 S  0.0  0.8   0:00.38
mixer_applet2      =20
 2607 surya      1   0 98448 9444 5340 S  0.0  1.9   0:31.57
gnome-terminal     =20
 2610 surya      1   0  2440  620  536 S  0.0  0.1   0:00.00
gnome-pty-helpe    =20
 2611 surya      1   0  4620 1232 1040 S  0.0  0.2   0:00.23
bash               =20
 2631 surya      3   0  2640  984  844 S  0.0  0.2   0:00.02
gam_server         =20
 2633 surya      1   0  380m  13m 5892 S  0.0  2.7   1:27.11
evolution          =20
 2639 surya      1   0 16036 2792 2476 S  0.0  0.6   0:04.02
gnome-screensav    =20
 2641 surya      1   0  4440  572  572 S  0.0  0.1   0:00.00
firefox            =20
 2652 surya      1   0  4440  564  564 S  0.0  0.1   0:00.00
run-mozilla.sh     =20
 2657 surya      1   0  219m  13m 6916 S  0.0  2.8   2:35.24
firefox-bin        =20
 2666 surya      3   0     0    0    0 Z  0.0  0.0   0:00.00 netstat
<defunct>  =20
 2691 surya      1   0 71644 2844 1980 S  0.0  0.6   0:00.21
evolution-data-    =20
 2695 surya      1   0 72784 7248 3640 S  0.0  1.4   0:14.31
evolution-excha    =20
 2772 surya      1   0 71016 3328 3028 S  0.0  0.7   0:00.14
evolution-alarm    =20
 2816 surya      1   0 31224 2648 1176 S  0.0  0.5   0:01.49
spamd              =20
 2819 surya      1   0 34580 4264 1256 S  0.0  0.8   0:17.31
spamd              =20
 2924 surya      1   0  4624 1216 1032 S  0.0  0.2   0:00.22
bash               =20
 3275 surya      3   0 39152 2748 2152 R  0.0  0.5   0:04.16
xmms               =20
 3316 surya      1   0  117m 5688 4276 S  0.0  1.1   0:01.55
nautilus           =20
 3583 surya      1   0  104m 4828 4336 S  0.0  1.0   0:02.77
gedit              =20
 4137 surya      1   0  4620 1248 1056 S  0.0  0.2   0:00.10
bash               =20
 4199 surya      1   0 55336 2496 1840 S  0.0  0.5   0:05.30
kscope             =20
 4201 surya      1   0 29240  900  832 S  0.0  0.2   0:00.05
kdeinit            =20
 4205 surya      1   0 17248  608  608 S  0.0  0.1   0:00.01
dcopserver         =20
 4207 surya      9   0 29908 1016  856 S  0.0  0.2   0:00.02
klauncher          =20
 4209 surya      3   0 29864 1652 1400 S  0.0  0.3   0:00.42
kded               =20
 4233 surya      1   0 29356  876  808 S  0.0  0.2   0:00.00
kio_file           =20
11127 root       1   0     0    0    0 S  0.0  0.0   0:00.00
pdflush            =20
11144 surya     20  19  3688  672  548 S  0.0  0.1   0:00.00
git-gc             =20
11147 surya     20  19  4436 1096  956 S  0.0  0.2   0:00.01
git-repack         =20
11156 surya     20  19  4436  520  380 S  0.0  0.1   0:00.00
git-repack         =20
11159 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11160 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11161 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11162 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11163 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11164 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11165 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11166 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11167 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11169 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11170 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11171 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11172 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11173 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11174 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11175 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11176 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11177 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11178 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11186 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11187 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11188 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11199 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11200 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11201 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11202 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11203 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11204 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11205 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11206 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11207 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11208 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11209 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11210 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11211 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11212 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11213 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11214 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11215 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11216 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11217 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11226 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11227 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11228 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11239 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11240 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11241 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11242 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11243 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11244 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11245 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11246 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11247 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11248 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11249 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11250 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11251 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11253 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11254 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11255 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11256 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11257 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11258 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11267 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11268 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11360 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11361 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11362 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11363 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11365 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11366 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11367 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11368 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11369 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11370 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11371 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11372 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11373 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11374 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11375 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11376 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11377 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11378 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11386 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11387 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11388 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11399 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11400 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11401 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11403 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11404 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11405 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11406 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11407 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11408 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11409 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11410 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11411 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11412 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11413 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11414 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11415 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11416 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11417 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11418 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11426 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11427 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11428 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11480 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11481 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11482 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11483 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11485 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11486 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11487 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11488 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11490 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11491 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11492 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11493 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11494 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11495 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11496 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11497 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11506 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11507 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11508 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11516 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11559 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11560 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11561 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11562 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11563 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11565 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11566 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11567 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11568 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11570 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11571 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11572 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11573 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11575 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11576 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11577 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11578 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11586 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11599 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11600 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11601 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11602 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11603 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11604 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11605 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11606 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11607 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11608 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11609 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11610 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11611 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11612 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11613 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11614 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11615 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11617 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11618 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11622 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11640 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11641 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11642 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11643 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11644 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11645 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11646 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11647 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11648 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11649 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11650 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11651 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11652 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11653 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11655 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11656 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11657 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11658 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11665 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11666 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11667 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11679 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11680 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11681 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11683 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11684 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11685 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11686 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11687 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11688 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11689 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11690 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11692 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11693 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11694 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11695 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11697 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11698 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11706 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11707 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11719 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11720 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11721 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11722 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11723 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11724 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11725 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11726 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11727 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11728 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11729 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11730 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11731 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11732 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11733 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11734 surya     20  19     0    0    0 Z  0.0  0.0   0:00.01 hackbench
<defunct>=20
11735 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11736 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11737 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11747 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11748 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11839 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11840 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11841 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11842 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11843 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11844 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11845 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11846 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11848 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11849 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11850 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11851 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11852 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11853 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11854 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11855 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11856 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11857 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11866 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11867 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11868 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11919 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11920 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11921 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11922 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11923 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11924 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11925 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11926 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11927 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11929 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11930 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11931 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11932 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11933 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11934 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11935 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11936 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11937 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11938 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11949 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11950 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11951 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11959 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11960 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11961 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11962 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11963 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11964 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11965 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11966 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11967 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11968 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11969 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11970 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11971 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11973 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11974 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11975 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11977 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11978 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11989 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11990 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
11991 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12000 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12001 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12002 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12003 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12004 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12005 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12006 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12007 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12008 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12010 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12011 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12012 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12013 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12014 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12015 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12016 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12017 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12018 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12019 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12030 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12031 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12032 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12040 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12041 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12042 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12043 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12044 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12045 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12047 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12048 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12049 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12050 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12051 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12052 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12053 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12055 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12056 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12057 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12058 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12059 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12070 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12071 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12072 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12080 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12081 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12082 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12083 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12084 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12085 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12086 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12087 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12088 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12089 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12090 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12091 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12092 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12093 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12094 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12095 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12096 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12097 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12098 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12099 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12110 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12111 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12112 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12120 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12121 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12122 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12123 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12124 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12125 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12126 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12127 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12128 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12129 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12130 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12131 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12132 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12134 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12135 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12136 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12137 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12138 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12139 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12150 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12151 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12152 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12160 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12161 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12162 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12163 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12164 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12165 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12166 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12168 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12169 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12170 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12171 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12173 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12174 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12175 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12176 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12178 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12179 surya     20  19  1480  144   96 R  0.0  0.0   0:00.00
hackbench          =20
12190 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12191 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12192 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12200 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12202 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12203 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12204 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12205 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12207 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12208 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12209 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12210 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12212 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12213 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12214 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12215 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12217 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12218 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12219 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12230 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12231 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12232 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12320 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12321 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12322 surya     20  19     0    0    0 Z  0.0  0.0   0:00.01 hackbench
<defunct>=20
12323 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12324 surya     20  19     0    0    0 Z  0.0  0.0   0:00.01 hackbench
<defunct>=20
12325 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12326 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12327 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12328 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12329 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12330 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12331 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12332 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12333 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12334 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12335 surya     20  19     0    0    0 Z  0.0  0.0   0:00.01 hackbench
<defunct>=20
12336 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12337 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12338 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12339 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20
12350 surya     20  19     0    0    0 Z  0.0  0.0   0:00.00 hackbench
<defunct>=20


will try to simulate that anomaly.

thanks.

surya.


--=-LVi8dz+az+wDiNfxEuwD
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
BgkqhkiG9w0BCQUxDxcNMDcwNDEyMDc1MTAyWjAjBgkqhkiG9w0BCQQxFgQUvlLmZtOb2l/sQrE4
dZOZcRqanYIwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0
ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhBvM37Rpr2H0nigNRYrIQbpMA0G
CSqGSIb3DQEBAQUABIIBAHaKhggyBFLWCj/BWVuwU3WkNtssfG3fNTU/9WzH/xWvwMcMrLPH2tTV
3+mS96WTTMU8SS3QX0mfMDNy5lTkNBZk7SUtJ52j1+9smH4500JWdeao9oPxWJ51XPxEc0VK9QlU
NO65c4cYQlgG3FuD7QyRoYLSktkw3Qp/m0SWdXiOCu1AsOtni+D3Tl3siBNjVS5V1JqP55GYgSll
7PjVpno6lONdpmwJFamp/WfD8cBoGUrFojaQIDsODCWKxZUqo0PaBYxquI14GR2zHG7IZllyrWYJ
AfaxRlW4Y8xUAt1VSAT2oMy5lqpi6Fc0jybVeWMQXT44yyoSYjPxNfDXXq0AAAAAAAA=


--=-LVi8dz+az+wDiNfxEuwD--

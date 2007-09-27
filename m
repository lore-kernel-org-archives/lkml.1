Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbXI0KGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbXI0KGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXI0KFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:05:52 -0400
Received: from host26-16-static.57-88-b.business.telecomitalia.it ([88.57.16.26]:43465
	"EHLO paros.rigacci.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbXI0KFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:05:51 -0400
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 06:05:50 EDT
Date: Thu, 27 Sep 2007 11:33:46 +0200
From: Niccolo Rigacci <niccolo@rigacci.org>
To: linux-kernel@vger.kernel.org
Cc: iiitac@pyr.swan.ac.uk, rzsfl@rz.uni-sb.de
Subject: PROBLEM: kernel BUG at net/core/skbuff.c:1341!
Message-ID: <20070927093346.GA29101@rigacci.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

1. kernel BUG at net/core/skbuff.c:1341!

2. I got a kernel panic, the hardware is a good IBM 206m server 
with 2 Gb ECC memory, Memtest86+ run several times without 
problem. The message on the console is quite explicit, so is this 
really a kernel bug?

The box is a web server with moderate network activity. The panic 
occurred at 2007-09-26 13:15:54, during standard load
(here the MRTG graphs: http://paros.rigacci.org/mrtg/).

3. Kernel is 2.6.21, from Debian Testing linux-image package

4. Linux version 2.6.21-2-686 (Debian 2.6.21-6) 
(waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) 
(Debian 4.1.2-13)) #1 SMP Wed Jul 11 03:53:02 UTC 2007

5. No problem for several month with kernel 2.6.17

6. Here it is the transcription of the console screen. An image 
of the actual screenshot is here: 
http://www.rigacci.org/wiki/lib/exe/fetch.php/doc/appunti/linux/sa/kernel_panic_2007-09-26.jpg?cache=cache


Shorewall:net2all:DROP:IN=eth1 OUT= MAC=00:0a:cd:10:bc:24:00:50:7f:1f:45:d9:08:00
SRC=217.58.146.18 DST=88.57.16.26 LEN=88 TOS=0x00 PREC=0x00 TTL=60 ID=0 DF
PROTO=UDP SPT=5004 DPT=1194 LEN=68
Shorewall:net2all:DROP:IN=eth1 OUT= MAC=00:0a:cd:10:bc:24:00:50:7f:1f:45:d9:08:00
SRC=217.58.146.18 DST=88.57.16.26 LEN=88 TOS=0x00 PREC=0x00 TTL=60 ID=0 DF
PROTO=UDP SPT=5004 DPT=1194 LEN=68
audit(1190732795.310:2): dev=eth1 prom=256 old_prom=0 auid=4294967295
audit(1190732797.310:3): dev=eth1 prom=0 old_prom=256 auid=4294967295
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:1341!
invalid opcode: 0000 [#1]
SMP
Modules linked in: usblp sha256 cbc blkcipher nfsd exportfs lockd nfs_acl sunrpc
ppdev lp parport tun sch_sfq act_police cls_u32 sch_ingress sch_htb ip6table_filter
iptable_raw xt_comment xt_policy xt_multiport ipt_ULOG ipt_TTL ipt_ttl ipt_TOS
ipt_tos ipt_SAME ipt_REJECT ipt_REDIRECT ipt_recent ipt_owner ipt_NETMAP ipt_MASQUERADE
ipt_LOG ipt_iprange ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype
nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_NFLOG xt_MARK
xt_mark xt_mac xt_limit xt_length xt_helper xt_hashlimit ip6_tables xt_dccp
xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter
ip_tables x_tables ipv6 dm_snapshot dm_mirror twofish twofish_common dm_crypt
dm_mod tcp_diag inet_diag ipmi_si ipmi_devintf ipmi_msghandler evdev serio_raw
i2c_i801 i2c_core iTCO_wdt rtc pcspkr ext3 jbd mbcache raid1 md_mod ide_generic
sd_mod ide_cd cdrom ata_piix ata_generic libata scsi_mod piix ehci_hcd generic
uhci_hcd 8139too mii ide_core tg3 usbcore thermal processor fan
CPU:    1
EIP:    0060:[<c023df85>]    Not tainted VLI
EFLAGS: 00010206   (2.6.21-2-686 #1)
EIP is at skb_copy_and_csum_bits+0x2b6/0x300
eax: 00000002   ebx: fffad000   ecx: c0004eb4   edx: cfeb1120
esi: 00000000   edi: 0000000c   ebp: 000005c0   esp: c2103e30
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c2102000 task=dfa07540 task.ti=c2102000)
Stack: fffad000 f78c26b7 00000509 00000000 00000000 00000000 00000020 f78c2bc0
       d4447eb0 000005c0 00000002 0000059e 000005c0 00000008 00000509 00000022
       00000000 f78c2622 d4447eb0 c023ecdd 000005aa 944099dd f78c2600 d4447eb0
Call Trace:
 [<c023ecdd>] skb_copy_and_csum_dev+0x75/0xac
 [<f8852d05>] rtl8139_start_xmit+0x5f/0x109 [8139too]
 [<c024291e>] dev_hard_start_xmit+0x1be/0x21d
 [<c02514b2>] __qdisc_run+oxe1/0x196
 [<c0243abc>] net_tx_action+0xcf/0xf4
 [<c0126102>] __do_softirq+0x66/0xcc
 [<c01261ab>] do_softirq+0x43/0x51
 [<c012640f>] irq_exit+0x38/0x6b
 [<c0114bc2>] smp_apic_timer_interrupt+0x71/0x7d
 [<c010481c>] apic_timer_interrupt+0x28/0x30
 [<c0102241>] mwait_idle_with_hints+0x3b/0x3f
 [<c01023b5>] cpu_idle+0xb5/0xd6
 =======================
Code: c0 0f b6 c0 01 c2 29 df 89 54 24 54 74 5b 01 5c 24 1c 01 dd 01 5c 24 2c 8b
 36 8b 44 24 34 89 44 24 24 e9 46 ff ff ff 85 ff 74 3e <0f> 0b eb fe 8b 54 24 54
 8b 44 24 1c c7 44 24 14 00 00 00 00 c7
EIP: [<c023df85>] skb_copy_and_csum_bits+0x2b6/0x300 SS:ESP 0068:c2103e30
Kernel panic - not syncing: Fatal exception in interrupt

8. Environment: see the attached gzipped files.

Thanks, and let me know if more info or testing is needed.

-- 
Niccolo Rigacci
Firenze - Italy

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="lspci_vvv.gz"
Content-Transfer-Encoding: base64

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
Zlkakogb5yj/B6XfQ+P/OwAA

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="proc_cpuinfo.gz"
Content-Transfer-Encoding: base64

H4sICAJf+0YAA3Byb2NfY3B1aW5mbwDtUk1v2zAMPVe/gsf1Eii243U9bod2GAYUBXo2FJqO
BeiDsGTXya8f5QTrDvsJPUjg03t8lCjyFJFSitPdI2i1UOjj1Nle0BOF2Qb6GTI5hTzDYLx1
Z2H2B+VjT+5O4uYaQjCeBG7qL6/38EIh29mXsIEfL29Q7yr99HxRKROzDScR15vt7+dLMaor
rXf14ZtCgyNBspfiV+nmAX59Vzyek0XjYLuaVskenZikIlEYJyrExhTLclCovRp6u3THuVQL
UY0ub+CKBq2HDw6jNx9o4LmozpRK2NGKxNnGcDuTIrYHR4s04REO6p3/qp2RWwmQNFg8QU/A
iSAnBJ8mYEPgkQDXBzBsERIx+DwJcyqMAfRxEVkuaXUL6AY3pxH6nMAgW/B+hWEVqyS2sirZ
YMyQPfCRIKzgvHQgpGxC7kpdDpIVg81xgj51yA4oZUB5Aq77FtbMkzrGU/SWS9vaRre7Sn7i
Vvr2F22jFP8zLvvPcfkcl+u46N3X9n/j8gcaHc4EXgQAAA==

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="proc_iomem.gz"
Content-Transfer-Encoding: base64

H4sICHxe+0YAA3Byb2NfaW9tZW0AbZPBboMwEETvfIWlnhNhTATklnKKqrRRU/VaGXs3QaUh
Ahqpf1/beEMgIJBWzNvZwTZh2F8L82SYILI1O/y1Hfyw980uYCy8A9xlgLyR7Yl9Q3OGKnCN
KTmgc2igheYK2oqSugsvfpYaauvOZAPSIooQJUfI286qSCp6A8rnZN6nSxD0RPbxOcWPMlxB
bIAXF5ypWoMjnLAyhBCQCjEQWnYyMM5AIyDtR2zy/ZZ9yKKC1umZ1ymh01/r8+JaV7IrK2CH
rm7kEQyNFBhxulqK1toVwom2Wpub62Vi0s4hcFLl10n5/pjEZNyPy4j6J0hVFvZDFS2VKSja
Pt+y59+WPYXCNQ9E6IneX5gRy9Ag81B3FMY+ovfRo7109gMxtpfrMHb2RuGEcHsi7hFxS/AI
pVxkXV33FhGpYm6KSmmJhy2aBJ0hJkHvofQGXaGVWARAmwhD/+V8YdaBBwj9Ji9sMT0i5phz
0YumeGzVPCY1mVEjb6zTmbFAY8H9a6Ox6BPjzLH9B6wmiK5EBAAA

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="proc_ioports.gz"
Content-Transfer-Encoding: base64

H4sICHBe+0YAA3Byb2NfaW9wb3J0cwBtk9GO2jAQRd/zFZH6TDVjBxJ460aratVuiyq6r5Hj
xEtUKCgJrfr3nZuEmBAkZIlz7szY2BARLYjYhZuwOBoOiBSAYgHnygJEAJEW0FbHsiZBS6Dl
iJBaAa3Q51f5Lz+ZuhAYA8axwLq18j3B92QYFp7NexnW5bsIA2GGoUqABSiGJIADcADufAmI
0Zq71nIE2siH3UfZCCPIbibC8FZVRSnnUC5ZyIKmTVlX5hCQjlcLLLO+GjvS3Y7+lI1xuSCH
rJtlZdSN6kdpjNKTUdYIkgWZ87HKmgrMgtkJQ6ntSrfpS2hPvx0HjItjit10OMnwQRGu51O6
fQm3r2yy57dd9vT1S+8T+Nz7bPf6ozOMSl5eTbr9Gbb7+tS2h7LzCl6Rr1RZ+s03Vmis3FV/
3j7T6Fbjfqtd+j37W7QBszwI5nx2CI0j6P5ZjqLoTnerLntbZXtbSF4B6rs8d3mvbvIR4PIu
r7q8Vzf5FeD9r627vFdVQpw1x/zSSEUCnLj547iq8R1qWgOs77L9brw6VLlpjaTzRFCeP0p7
5dMW6GFvr8a0xTgbP0p75dMYZx/29mpIR7i4yI3v+OnShB/ISLg3/Z+772M2pLvbnsqE9bo9
nVASgUbTkkhKXClPWBaePP7rG/0PhNP6AO8EAAA=

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="proc_modules.gz"
Content-Transfer-Encoding: base64

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

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="proc_scsi_scsi.gz"
Content-Transfer-Encoding: base64

H4sICKNe+0YAA3Byb2Nfc2NzaV9zY3NpAM2OsQrCMBiE9z7FvYAQK2LIFlqkharFFveS/NBA
SSSJBd/epJODD+ANd8sd98kYJzWThqbVKAqiaFyIAkEFw1DNk7W0CDCGVm/RvWzOAniQ1c4L
yFFi08Xp3G3q4VRyxlnfyQNnwJ1Wgf5c3tJofD9JpG5tPKm4kyp9BvyQvA4tMFTJfUILxuXf
4xfe/h/xPtiR74tQAQAA

--opJtzjQTFsWo+cga
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="ver_linux.gz"
Content-Transfer-Encoding: base64

H4sICDFf+0YAA3Zlcl9saW51eABtVU1z2zgMvetXYGYvuwerlpQ4aW9Zx82k6zjZ2J7OnjQU
SVtc86sklcT/viBl2Y1THcRHAARA4JG834A3isNGcMk8EMeBKxv2YBxIY3bQ6c53RMLedKDI
HlrywoFoMJLBC3deGJ1nU6NsXBoMhJYD7ZzjOoASWihc6/iPTjiuUOZBaLg1tIsTEnD1p2lL
9Jb7PINsLnT3BujKeCjzSV4Wo3I0uZ7AHwUsH57gO2fwrZNQFDCuvlxWX8YlrFdTKMfjKxDR
8G6x/pS8oLc73cEUPnwXeZFXSanIjp8pq/y6yBp0EIT0Z7q/D+Is/kcy5frrV+ZF6TJlOtz6
h29Qsk7yEdYljIIxQ4gqr0bW8aLIeLnx1pntWewivxjn5aE+U5iLxhG3P/me5EV2u9dECQqY
2I47+FMy9tdR+eQMtecbioHL/Cpb8HfZnIJOxtha7Q2mfKbHbLCIy3b0u0Jd5p+vso7xl49l
wNZdZA+pCh7mhjDs6PD5lpSXE6ANhUbuqLAtbkNvPAP+Zo0LG4+UpDsWZTWhEnynnaVgbQwl
bSROtIPQafC0rf3mBxAaamukoEhL6euuKpNK6K3j3ifchgaEnQTSSF5vhAwYVth+6sgrvIWa
GhUJG2Fyto9IdTKIFBCt6/X88S6B1WqexhBkP39c9nMkdRyXNw+zBJ5n32bT1QHe3j8PE8dp
jBWhedV9MvVitnq4eUrw4Wb573r2fHPbuxniCuviQUp4Nl2kkVOdxul8vVzNnu97B6TtB8Zc
2FuO9aw1wQQ3wQ7Ya2Xrhnjk0yARR6W1J0MkazA1FnMQCHdc0lZlNeBffBNFNCMQfL1TSUiN
1sERuhtU72RDWifJIZWToE/C03PDIdFzy0O6J7HmIR6bD8JGGF9r/15+2OFJMOzzJIkpI0MC
tQpJFlmzC6nUEbZ7HwmLcPEVG7me9TD28S129/mfxC7idv1I4yCFEol/kuttaCNqubTIjoiI
b3sD5HGdmJuiMkptT99DYnEyfVwshiBRMQSazm+Wy/uv/x0S71ha6vGW5sfjgO07dPGsJPbl
4p3kuAIbupWx2kOJB8XxoB3zHQA6mwBTyEFifWtCxEo4h09SeDUb4dthTOfS6GhA3d72loYB
pl8zQbb42PBwQFYJJE4/YvmFDpt+ovwWXyAmMRn+EhsjSlqL63GRADXIFc+dMOkuEKvpY/3K
Aljq7c6BCxRvp1DB/w0D1VBC8f1zRLACFEu5CMbrLcdjjEfJn0SUAWXOKCCB1FaItwQGQyka
nOLt5EVakQwGZVoe07ouqs94L+M7K4C3VNQteg3bCrph0vkmWeKr7OJLjPSneO1hJTdEZz8B
40oBef0HAAA=

--opJtzjQTFsWo+cga--

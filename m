Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYBIPAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYBIPAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYBIPAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:00:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:17489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYBIPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:mime-version:content-type:message-id:from;
        b=TlmUNkn/JJwCFrXntlc7NuYNWv+/Lv4MLqMmnj7Al9D55VKGFg3U+oNn9X44O3MjysS148MMvz/i6lMd4it413YDoWTelJDGr5mjaVgeAyv0onaRk2AjE52cIKNbhcPy5yIE+0fqfUyUjOI/RogjMZT5QfsH2C/ggF54CrMsjqo=
To: linux-kernel@vger.kernel.org
Subject: acer aspire 5720ZG APIC error on CPU0: 40(40) ACPI/USB
Date: Sat, 9 Feb 2008 15:59:55 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_r/brHbjCmz0O9Oc"
Message-Id: <200802091559.55625.zouhair@infonux.org>
From: Mr Souissi <zouhair.s@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_r/brHbjCmz0O9Oc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hi
my (DVB) Pinnacle pctv 400e, freeze after error "APIC error on CPU0: 40(40)" 
in syslog.
work without problem in m$ windos
and, test it in other computer (althlon 2000xp) with same drivers, work fine
my webcam logitec nx pro, freeze too, after error "APIC error on CPU0: 40
(40)" ...
found same problem here 
http://lists-archives.org/video4linux/18626-dvb-usb-bulk-message-failed.html

booting with "noapic" give same result :/
kernel tested: 2.6.22-3 (debian testing), 2.6.24, 2.6.24-git14, and 2.6.24.1
is ACPI bug ? but why i get problem only with usb ?

cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm constant_tsc 
arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 2929.49
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm constant_tsc 
arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 2926.00
clflush size	: 64


lspci
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express 
Root Port (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Contoller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 
(rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 
(rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 
(rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface 
Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE 
Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA 
AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
03)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M GS (rev 
a1)
05:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M Gigabit 
Ethernet PCI Express (rev 02)
06:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.11 b/g 
Wireless PCI Express Adapter (rev 01)
07:00.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 
05)
07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 22)
07:00.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
07:00.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 12)
07:00.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)

syslog
Feb  8 19:22:38 zz kernel: uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, 
period 8, phase 4, 93 us
Feb  8 19:22:38 zz kernel: uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, 
period 8, phase 4, 93 us
Feb  8 19:22:40 zz kernel: uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, 
period 8, phase 4, 93 us
Feb  8 19:25:25 zz kernel: usb usb1: usb resume
Feb  8 19:25:25 zz kernel: usb usb1: finish resume
Feb  8 19:25:25 zz kernel: hub 1-0:1.0: hub_resume
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: resume root hub
Feb  8 19:25:25 zz kernel: hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001803 POWER sig=j CSC CONNECT
Feb  8 19:25:25 zz kernel: hub 1-0:1.0: port 1, status 0501, change 0001, 480 
Mb/s
Feb  8 19:25:25 zz kernel: hub 1-0:1.0: debounce: port 1: total 100ms stable 
100ms status 0x501
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: port 1 high speed
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001005 POWER sig=se0 PE CONNECT
Feb  8 19:25:25 zz kernel: usb 1-1: new high speed USB device using ehci_hcd 
and address 2
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: port 1 high speed
Feb  8 19:25:25 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001005 POWER sig=se0 PE CONNECT
Feb  8 19:25:25 zz kernel: usb 1-1: new device strings: Mfr=0, Product=0, 
SerialNumber=0
Feb  8 19:25:25 zz kernel: usb 1-1: uevent
Feb  8 19:25:25 zz kernel: usb 1-1: usb_probe_device
Feb  8 19:25:25 zz kernel: usb 1-1: configuration #1 chosen from 1 choice
Feb  8 19:25:25 zz kernel: usb 1-1: adding 1-1:1.0 (config #1, interface 0)
Feb  8 19:25:25 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:25 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:25 zz kernel: drivers/usb/core/inode.c: creating file '002'
Feb  8 19:25:26 zz kernel: dvb_usb_ttusb2 1-1:1.0: usb_probe_interface
Feb  8 19:25:26 zz kernel: dvb_usb_ttusb2 1-1:1.0: usb_probe_interface - got 
id
Feb  8 19:25:26 zz kernel: dvb-usb: found a 'Pinnacle 400e DVB-S USB2.0' in 
cold state, will try to load a firmware
Feb  8 19:25:26 zz kernel: dvb-usb: downloading firmware from 
file 'dvb-usb-pctv-400e-01.fw'
Feb  8 19:25:26 zz kernel: usbcore: registered new interface driver 
dvb_usb_ttusb2
Feb  8 19:25:26 zz kernel: hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0002
Feb  8 19:25:26 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001002 POWER sig=se0 CSC
Feb  8 19:25:26 zz kernel: hub 1-0:1.0: port 1, status 0100, change 0001, 12 
Mb/s
Feb  8 19:25:26 zz kernel: usb 1-1: USB disconnect, address 2
Feb  8 19:25:26 zz kernel: usb 1-1: unregistering device
Feb  8 19:25:26 zz kernel: usb 1-1: usb_disable_device nuking all URBs
Feb  8 19:25:26 zz kernel: usb 1-1: unregistering interface 1-1:1.0
Feb  8 19:25:26 zz kernel: dvb-usb: generic DVB-USB module successfully 
deinitialized and disconnected.
Feb  8 19:25:26 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:26 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:26 zz kernel: usb_endpoint usbdev1.2_ep00: ep_device_release 
called for usbdev1.2_ep00
Feb  8 19:25:26 zz kernel: usb 1-1: uevent
Feb  8 19:25:26 zz kernel: hub 1-0:1.0: debounce: port 1: total 100ms stable 
100ms status 0x100
Feb  8 19:25:27 zz kernel: hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0002
Feb  8 19:25:27 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001803 POWER sig=j CSC CONNECT
Feb  8 19:25:27 zz kernel: hub 1-0:1.0: port 1, status 0501, change 0001, 480 
Mb/s
Feb  8 19:25:27 zz kernel: hub 1-0:1.0: debounce: port 1: total 100ms stable 
100ms status 0x501
Feb  8 19:25:27 zz kernel: ehci_hcd 0000:00:1a.7: port 1 high speed
Feb  8 19:25:27 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001005 POWER sig=se0 PE CONNECT
Feb  8 19:25:27 zz kernel: usb 1-1: new high speed USB device using ehci_hcd 
and address 3
Feb  8 19:25:27 zz kernel: ehci_hcd 0000:00:1a.7: port 1 high speed
Feb  8 19:25:27 zz kernel: ehci_hcd 0000:00:1a.7: GetStatus port 1 status 
001005 POWER sig=se0 PE CONNECT
Feb  8 19:25:28 zz kernel: usb 1-1: default language 0x0409
Feb  8 19:25:28 zz kernel: usb 1-1: new device strings: Mfr=1, Product=2, 
SerialNumber=0
Feb  8 19:25:28 zz kernel: usb 1-1: Product: PCTV 400e
Feb  8 19:25:28 zz kernel: usb 1-1: Manufacturer: Pinnacle
Feb  8 19:25:28 zz kernel: usb 1-1: uevent
Feb  8 19:25:28 zz kernel: usb 1-1: usb_probe_device
Feb  8 19:25:28 zz kernel: usb 1-1: configuration #1 chosen from 1 choice
Feb  8 19:25:28 zz kernel: usb 1-1: adding 1-1:1.0 (config #1, interface 0)
Feb  8 19:25:28 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:28 zz kernel: usb 1-1:1.0: uevent
Feb  8 19:25:28 zz kernel: dvb_usb_ttusb2 1-1:1.0: usb_probe_interface
Feb  8 19:25:28 zz kernel: dvb_usb_ttusb2 1-1:1.0: usb_probe_interface - got 
id
Feb  8 19:25:28 zz kernel: dvb-usb: found a 'Pinnacle 400e DVB-S USB2.0' in 
warm state.
Feb  8 19:25:28 zz kernel: dvb-usb: will pass the complete MPEG2 transport 
stream to the software demuxer.
Feb  8 19:25:28 zz kernel: DVB: registering new adapter (Pinnacle 400e DVB-S 
USB2.0).
Feb  8 19:25:28 zz kernel: DVB: registering frontend 0 (Philips TDA10086 
DVB-S)...
Feb  8 19:25:28 zz kernel: dvb-usb: Pinnacle 400e DVB-S USB2.0 successfully 
initialized and connected.
Feb  8 19:25:28 zz kernel: drivers/usb/core/inode.c: creating file '003'

More info... here http://linuxdeb.free.fr/tmp/

attached files: config_2.6.24.1_core2.txt.gz, dmesg_2.6.24.1.txt.gz

Thank you.
Zouhair.



--Boundary-00=_r/brHbjCmz0O9Oc
Content-Type: application/x-gzip;
  name="config_2.6.24.1_core2.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config_2.6.24.1_core2.txt.gz"

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
esAAm3EAAA==

--Boundary-00=_r/brHbjCmz0O9Oc
Content-Type: application/x-gzip;
  name="dmesg_2.6.24.1.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg_2.6.24.1.txt.gz"

H4sICM6yrUcCA2RtZXNnXzIuNi4yNC4xLnR4dADUW3tz4kiS/1+fImNm4wYmQFaVBAjFemJswG2i
G5sz9Mzs+jocQiqB1kKi9XDb/ekvs0ri4SdmZzbuOhoDqnzVK/OXlcWnMC7u4U6kWZjEwPW2zi2d
Nb9nTS9JBYdamiT5r9+/16E297w1oaVz3QRuGLbBmAW1VSpSEQk3E0jYF7PQVTS82anX4UcGk9EY
Jm4OZ2IGXWDMYdzhXegNplKKdjq8nDRXaXIX+sKH1eIhCz03gquTESzdlaOBJBA2NxwwHv2D5vaj
buDho1qRubNI1F9iVFQ7jK6UVUtFJtI74b/IKp7oZMZ+rOyxuZ3AC4Txlrlrqm1G3+juoXNNt8Pa
4nvoLKl2GVv76VR0O6yz2T46FdUuY7CfTkW3zSo67T10llQ7jKXOk954CBe/TV5kfaozKJeCZPXd
3H2JN3i8FuxqNb/RVfF01Qd7sgbCe8KKj9herD6zHrP6zN2T1XvCyvczWDw1WOxn8JMRZsYzw/S7
m8ZhPIckjh7A7rZHp/AtjCKYCSgy4eva50yAC+fDD+ejwQhETEvJh1uRxiLSNcXx6fJ3anTv3DCi
dl0LkiL2pdMbjZs5PQN0ftJ8NjO0QZyLlNS6vn/jenl4J25SN56LmtEA/M951+y062CgwjwNRQZJ
ALzVljZp/0xiAeOzC5AsGTpH6I9OYPsfdvsX+cEyum1sv0jSJbpTWD9T7UqPNkrupInfSXCWu2ku
xQdJCsL1FhAnvtCEm0YPN/TxBj3yNfsCyvAtSzSp2nlkRKnkMpZy8Gme5G60csn0qlH1gPQ7YHKQ
jbKz0oilWKLKHSKjpKlmcqfRMtqWam/Ap+HZJczc3Fs4xmYgFB3Drf+irh1Kzk10h8/INBmSbo/f
xrTHIvujIQZYNIxsjnNdIx/hwNWkP6aVcTYwOM2+wTGephxOeleTf6DrUVR/TPpT6JwNzgZMUbWJ
ipVU9Da+6vem1dCz6l0ufLOScoZvUkofH5OUM5JivSxlNDmbPpHSr2yxpBS7JbcUe6cUtGVCUjqn
pS2WUbacjIc9Kd8sW9r21ojsK3/UO/sgpfBSitk7wMrJp9IWpqTgkjlAyvl4oEbMqGyxD7GlHHcp
BqVYPbUGYLy8EgEx9lbFeClF0NDB8GL6ieBVizHWeSJloKRwk+9IQRnGNMv3lVKtpBPjsRT2thTa
Er7IhZcLH+fdE2nZMB41p+FSpDC8hHGS5rir7i2Eiar1U0LYUC4TdKC4nTJsrmJFRSOba663Cm9C
/9q4N9BjRe4q9MqvxpfKm9e1cZp4KAX36o8GtB3WUsLXsPhloXxXKHteKHtT6M0FDsUjaxfhfAHC
nwuIwjjHh+xL/VUe/irP8FJZr2itL9XYXdPYKWDwBeZZeDNDGH9tIJ/iwI8OlH0Eq7HugMkbO8Ov
RDTgw2QIRpObldqL6c3kqndz+dsV1GYF0gL+vQnTr/hpHiUzN5JfOPhBRK/624zdbcau6nQk7sSG
9+q/DeWAZw+QoMUp5hX6ppG/1th9pnFAs0oRW47hEgMZhrmzyM11gM8ZNTAYHl3K5mx714c+rV3b
sNsuNxjQ2DpyuHy1WhWzhIu10Ul/Wpchg5CDl8RBOC9SN6fRDuOAAhJ91k6iCHdATozj3pBiYFKk
uNZU7Ja4IgfbrtDOHBMoqOCl0y4/1LXTIoxytJvCVhRmeYZKQIKLJPVF2sBuzsIozB9gnibFSsEk
7O+U4jesA3inZVvaRwmI0GYMdYh8cKiwm5Q7Hh/54u4o812OX+Fu7h53ukzDeLjCIZaDmSeAYC1Q
+UG1i+sVSblqSyK3JPJKovW0BC46m7PxZ8hchCRkAo5KjimsruvgY5+2prCIl252i7Inw1FfMol7
T6zkMGfFaoX+ZsM1jMM8dKPwO3H2xp9/NLTxsA8LN1uAAnYlRHMUrqrJsUNsgbuDtU3bwnWUi6yu
9Us/B8xqm7rRasHo/DuCgdJJ6FovibMkwmHzkgjnE/xiuXxA93gXegKn7563NE+RwHWeP2z8F4pG
Ex7AQ6wmnrWMmczo8LVtnQa0uMVtu7JtSMis+TJ/u9UyN11rI0Btc2atuzYSyyR9cKBrsG6L3x51
WadlWLcbQAw11u4atyVsxg76AkenhYH9do3gGiBJKGdC+Yzf4moMcwwtt3J/I4iqa3dhmhe49ko5
S6kXHfBDUuSORJ9BeI8LB0DuMVxUVSJKX2RGgDQ14DhRt6d1yXGHKA+3k+IoN03FMTMrDsa6MCo5
ouQbalY6vK1sDNnLL8SBqcGaA0CnzpQcZqtKyemLLdZWMb62CjloJEoO7rbdrl1xtEzTUxw4Ytsc
ubivdGyOGjbsoKZBcvQWwrulJR0GkC/CbLMQYZHEuPwyfCzg9zHM0G50reSBaHfgXIVERS6Qdsnl
ra4tViIHDwfxlghznNI5uhOR4tLs4daZpcpX+QJnCn0rfc5ldM9WwguD0EPXUCAJCsSp4V29xeA0
mSej4XgCtWj1r+OWjWPGeV2bCK9IySWdpe5SfEtStUzkDkV1k8EnOtBC39wPM5WqoSucoR/C/eWu
3NKffZqMdthGmK7lr6z/FuMa7n2EKAF2C+YixvTNQ9+OFGHw0MCtt0KyGZ0IzIIAeLUqjGc/CLPr
P2li6yfaMkHbkvRo+c3FwQ+Emxep2OQNagRVI05K6KOp+SIVrp/pysxPGIyUO6B06mODHvS3HpRU
vHrEMOkoH46ro7cNfBn2cU2VreuHPfSt2y1qZHAryYHN9hwSs2vtNyRDzJhxw6O5uEzAo9ULborf
yKnS6JSOm1L252hTQa00blUKj85eunNyvMsVrpK7/uQSyqhThhvamvpmr/y0iPKfsH9ZnhYehQu5
AT7qGoVrN8IBiF1KibHf2bcwJ/1zEvV5LF1eCQvkyKXo1ksYaHQMxts0ipg6S9trV3UY09IqlvSx
Ty6PjMXQy9GTA/wKTLfaHzB+4DZbychs+G9ZoTAFmnGK24GebbY8O2IgwpVE6k8jHjtoF7d145ld
zA3eqv8f2kv/8e3C/n9vFyaHjP17C1UBSDrS2qzBTB0nuYSQarhQWnqLr5dPHdHbxcnpp+HFBwSE
TYkIEahnmq5Ph6PBlYNJiYezfGzcm0zmKuzYAFTHjrn8yo+bjL7Tu+ZV+3k66UH2EHuLFBfJd4Wz
r6VToJMr2V1MfVZuJk8CT3F5zxc5FCu0GxszuWUxvuSu2mMZCvabfrJ0wxjRiPpA52HZysV3E8O0
BNI4zzRXMqSwA/k5itBikd/EGAax3cNl2S4BmXYxmDpwtQ7CNMh5gqgSUfIyjB4Ql5auiLKq/GGF
+8ELt6M2ZhVOmdaMRr3Li7PhB4y8uVwQ2H1MM2LfTf3d7KOUOehRgp7cEuGgRwGKzovKRjqohZvL
ybAm43QdvhYCEVw4jxMy9C506UygSsUC+EFmt0kWHkv6H4AifgYztIUSlJUsOUGckOegpKO4bxLH
r3dzkerlIW2SziuBdOyKW5+2XoWdVUut3A8ZTAyYmDBpVZmkGoUyC6HULCQhabHKS3c33+p3nMTN
skcbKuGJUOLbHW+8IVhuQgPJ+DAewDHCNuY1KKN0qpzqCEc9x/mitjZCcAkP5Re+xe2nqCtViSAO
KMGD5xTRxF1hGIBTTG/nmFDgA0woajJDpMSKCL4WYXrryHWBG8OwDKNpWJ0AkZ6Lfl8myMPeeVsm
r0cfxsPLo2nv8jnOFnG2zKecxKQW2zR1Y1zGKcHHmbJJHdyjNQ4TurFl+HDdoys1AzCVcO36f24m
pzc6dUW/GV9Nv7yTZ2zym4MYB3+M+aGM5qGM1mF9HHwYv8KIu+wWrj9dfDzBxUAeFkywoAUdKtoa
8DNjmNjWX2c9PZy1dzhr/3DWwbOsihN+NnCrlbmE/rqcs6dyfl4Lep31w+HWn7/KKt0mjKNiLg9F
xoTdJsrXwZ2hdztQ8+pw4rtLOCVgp63iFaqKx+pIisDJk1gRr7ZjxQ6DA6ryhRaog4sqKkhpOyKK
eDvgxGMKDc4mbUMXIXnGF+PtcCSfkRvGLq8dsGzHaOFWpyV+IrL4p1xGiwbQ2cgPGOGOiV6E6dcf
dCByxIMLEa0QfK2SLEduhXreDJ/2mxTckDkxhm7MK0aj4eXWiV9DIhfgDbAbsKYzMXo3KdWWkBpN
YpbJbGYbcP69KhRNe4gSY/jm3goI0mQJE0ujU3IH8sxT+bcKxZTDYoyUOTtGgkgu3ewBjV0CeVSE
b2Eil4Cs21GwaVuiKd+CDfO6tvYqa5ucO/59PyOTjLhU3sloS432+zXKCHZPIeydjDKA3VMEeydj
EHCvKd/2YaVTpYqzKvMjtwjUP0QCReQT2qHy9F5Sqtp7U338N6RYGymdw6XYGyn24VK6GyndQ6V4
1ejKj4dKERsp4lApJl/PtPr4ohTp587cMFInFK4qAwiQ0koYDj+2HSnl126VHpK7VFCKIZpCKCXl
KOTnrEGWwXQqkKOv+hbGfvLNATo7bbawU1TiHozWzyvBzS5XCxPbx1eDs8G0d74mquoNTbtcvc9r
Zd5jrXKhWc9odc1S64y/qLVrVqaZb2hlu1qJr2k+o7VbaXVf0WpVWq03tPJdrTRRTf6MVpuXAruv
aG1VWltvaDV3tdLZcJM9o7XDSoE2e1lru9LaflWreDyvGxD1WGslsGO8qPV1BLa9hK8RuWLyTkVI
1oaarAo26Mi+To8JNWD2K02uEtoIt1DsPZSHWUlQgYhtqbTd2tarymkl//nKSep+ytn16UZ553nl
nXcrZ/sp59e9jXL7eeX2u5Xz/ZSb1/2N8u7zyrvvVm6Wyt/HJ9bT9SZG1IZjiWDFK4U7k3fo8ktZ
eGs1qkpeWXib9sYgMuIJswXq2KP2h6CTGZbd6rS3hcxwn+1R+XtSOEReB87XfNm6aE2neNuWVXaT
HilT6cV8P9lOJrytslS4dDE+hplMQlJ3GWS6rv+988tEHqOoECgr/xT6okKe3tERR3lUCUzblxI9
FZVSMu0sFUJqJ41+WV+kkMSNW4TcAi10Cz/MnU31iMhjkUeUjmVUAcuhVnmruqKuMTr1bnUMu6vb
JndY3dmpPv12phKfW/haJDmiRJ/eb9p6C6NUnz6/Uppi8r6YnB+6OShr0OXkhIk6UiwibIuTZCdt
22l04zz0wpWbUzn1JSJfuD7V9V8k8IKvW204DCJwiyivy4ID0M3upNovOKtPEckBDtnNsnAe36zP
uG7ktJ7JHHQ0oUP9quZXXZoQ8j4R6kpJ5vW2TAdzRERxX/Ym5fuTml8O9vt/Wh9J5p593JDy/UkP
6CP7C/rI9u8j27+P7OA+8r+gj3z/PvL9+8gP7qP5F/TR3L+P5v59NNd9vBOZG8wc9OvuUsyKICBH
iMDivlveFG9sVYPl3RBbPVW1zzazLDpckrUsZplm+3YtUvYafRw553uM4Pes3ZB3oiIRz/PFMccI
3FA3qI7ZmosQgroipPhpEAOXvGUcJGQa5azODNOvDcsydCDDmIMhZ0Vne+r29jGRerNu22zI1pUb
UcVk/XwmdiWo0scxmDMLXy18uUB3TEyP4QufefjMa+Orgy8bX118efgS+ArA9JHWR1qf48vEF/L4
yOO7sNaUeWkS0QUsKgz4qftt3TJNC0GXnhBhZBgRjw2n5bQdRDvZIgxy/MoYPjE0usdB3cQoaOpM
bzcxS7KODPPIxKQ6ShKJHCjbXYWyykl4of0LysRhz/+1EnMpHrhtdLplrayBBEimTi1r1XwhRrJt
q9UqaeDOrG/dz9qp45SXteQignIVlfuDcX5vGVowMxz4bTA5gd8+nDxHqCFckKeoE8+N46oPdKTq
ualPqGdNcZGos9z/Uie5pSJpvTxJvFlX47YvGdJSnBXZgxZn3s18FSY78EXDXYKfERrylnHEEJ0Z
VRnpb1flNQXEGXrXgL+BpdaKPMTE6XHTrRqxdnUy6g8nHyvuLYzjUD5EP+bCdXorf81gsy7/qOZD
QpiZPL7Er9r4AjHleHLEAUc8pzWDsq7xqWEapvPxtGc06EvATGc0GRhf1KZtGw38YwHdCGUNxrUM
e5Ug0LINi8PH0740/BnaXcKTz3+8RMi1ZUhlVmnaMikyUY0/VegQStKsUUWfyEpU7W2DpTfLsm9T
dMr7okP6YVLSnCzQVK8oS3sVei1ieX9155Kco67UKQwbxqsCMezJVJXdIll0R28PHJkeZgmVdhGG
Hnm41bIjSa3+Go9uf3dOel15K35w8uQO+XDvO+SdbpuRlFa/80RKbyOFPZYyUlc7miN5tWP7Zzu0
MQW5T+g1GfnEXOxJzd9FbZbU5cUeug5QWyXfVAE2p03YY9c99gV6mCBzfDOve+b6QvbmdghdOqDy
67oKbdOFriTP5X1VJevJqJ2cyVEzHv0KgG7ev2Pse30lxTafSOm9KUVeYDi4x+zNHo/cdH1Ro4gz
lfr4hcA5oKCFYIMeUOvCjeRluB7Xy5rI5lLiK0URZdZ0IeRvfeTd5+vpP+nyfQ29YK+uFdmMfgjr
bCc2sfi2FZxLZ4eEQbY/+aKYvUhcFbHWgrV8buqec2fqNubiF8mdWM6wpduQt8fqr5yPtGR6tX0s
9WccziipJeT7PDmFzzGZmuEQnlMlbctvDx93HDthvH6g4/4l52ju2uBi4YU3C8/faXPg8zma88j8
l2hplqjfVNDcTF4DFPyl6iU2xIWcJfaSEBlUEBdiOKZfBQD9JsUw2oZn0MqgeWfOox8B/MjAWyQZ
rmFZ/5PfKNjgagLWRMGyI2gYPShRwXYTL5Fe9ZsbTeQLfDwN50lswvUKsWOc1E57o26rY3eWdbqm
CDPD4DA+/0eNntVxZ9C8De7pCl1Wx+B9hHCZXsYp9qI5hUG+oMhDM+qwmWPaTot+/eLYZqnu6g/v
f8s51ubEjeR3fsV8C9RZWBoJhLlsKjLYXhKIicFxrijX1iAJo4uEOEn48e+ve2YkhJEAObt1W3Xr
WhuJmZ5HP6anX/EmiDGFEL3YveXT3dXNDOTfaAB7gh+syTX+efAid7KGEwubTie3Ns87lFCcgH2J
Xuwk8mdmmzuWoAe+xOD+mfCmPtaAMjFvgow2fuIpoDQl/PFKGfSvUpLcKjlmU1WZv14yWvMww8OK
YaJIXrqOwfrSi4PIjXFaQk8b3PLjN/5nli4C50WyxIhGaPnp9fUYuectt1QrJHeqViZ37QC5axXI
XatG7rQMCM/xUffJnQG5w+xRCmIsG4rARMZ1p6IDEc6P3WSppbxBq/AGLecNWsobkx7gI97MJdbz
Fjvfm2P0VZYJBWQD6GLOMQeF5uzINqoXI1uriGzngGxzKsg2p6ps08uAcGRr+8juZLJNr4I/vRx/
ein+jiBix1/ylbwGzgGucypwnVOV60oH5IfMxT4i2hkijCqIMMoRYZQiopdTwjBSJdPk6o7r8yBG
uMjD2WKanQuyihvHMPctnE1OZqYr2khaAXO0GuZaHA+6IhEOi5BnCwKQsxQGp2wwDORKEy9p2Rw4
4jv7iDcyxLeqIL5VjvjWxziQNc1vgEeAKvHoFhxDZpdcFeIxRcFpG1ICugra22VAUGl4EiYIeQwI
3w/3vHBzCaxap2jSwfCQLI4fA+YKNqNsmBx5YPSI+nox11XDVtWyDrgwCueMjCw+ExsJeMf4SKFH
aSrpuzbeSYyUxtpVaKxdTmPZV0ZFKW9+k+O2nMacgzRmfJzNS4aqQnNmGZCvSXNOs3SYnFKQo7lO
Ic05H6c5swrNmeU0l33VPp3mzPf3baoW0xytQnNm/r4dwl5p+gUc24sXBZaF0aO3sC8KvoTN0fgF
rcEz2T/NKH0kPAL10ywfaMMrEOE37JWMGXqtoSngAl4N7s4HU9xBzCaNP82Mc+OxxmDQLXIWeMDk
lN/DTAitT1K1CsZYRV/E1tf1BucHL1j7boDmN0fQKyb71tVX+NoJMeI3wKosqYsm7V4EGq5uNk+g
v72bTr4MRuOhcPOYW0aVOECSZzZPEBcVewRHnhFYKNz/FFPbnh+cm70Ydm8FpHKW49+CKVhIzZi3
1cR0XWSw2A8TDOQWi9bJzXyNtRVMvm4ysaaWsPQWrcdnTxivYWAQ8cr+D4lXyYKsA4LBgrYfEjT7
x/4mIHjLJxVF3mKrHsXIGYaQPDyookSOuUVyzKjFduyppEtwCfxByz/Q9AGuV7CdYsVAo/f9kXWu
6TphcxaRAEn1Zyk/0DjJSUE+41YKSdNBKPSDUDo7UPSPQaG5uWQbd5pw8lzXFWzODxLYQPSiDPrd
y/vJTFUQKSrVgV9v7gf92bxtqKbdwgR3qi/Mi8e/p1Xq+f3noS2bNYiWliDI+mQiUpE0TScTecSh
lbhRVZH6W2eiwScJhwF6MiwFxP70dvJ5cGmR0a9aWzdvJn+ekf5Qbam/nOUQB8dN1k/XaAuD7Dsk
5vmDMTREQxHRQHEZXlpGh/zW+x3vKetkCa3PddrY9s7FOqEhKAOfreq0TcgRKd9qJ3xZbfdYfbfD
OWI83BraIkcRYGD+Q/peBItULBtN8Nywj0D4v/cbx7eNjH/HYlbWbxOQFC0c+Mva817zQkHr5kpH
avTYOaB9bUO0gColE65WR/khJ8pfGPkXfaEz/BA7PwDFuU4MZO2IrGYlzSVEtx6WmeF5KoGbLEMn
rsXOdhtnscMec5TT0qiCbmKyZJHzwjC3VtASVltQ0aeIVSD2ITxEHoYpCJ8/qlbhYlHQbIShABN3
xcvGwCHBCE/4LQUoU5SlS/aMYFmAvZdpfozU5Eh/fEuAgq/vrf+npRKA1cVfGuH1aeCXTn7EP60f
2z8B1YDwHe9KfZiQHTiYMLOAT4mP4fuLNpkHTsC4v9gVAl/jwql1oL+Z9Td3+ndE/xafXRt/meSn
gi2weNow+m3RTIlu9QrOJw9Ok+fUDYz+7H+gyB1xn3ah41dLG2O7z4M+eQZFU5M9ZrsQHjGsEuai
5E2CSgZhGD5hFvqSg7oTybFR8ai0aFSV/Jr6qGeFsIrG1z40vl48vlx1pcGr+BEBPTXxFJ/D53Px
Cj/yorxNG6Qubba76azwpeyOVGekRyKvgmdNQbRPrf4ffQXjL+5/UTotdXIGp3lbyx2Lur7tWnSu
wff8NNFTKuwBvNtRvuZkOhR5NxbhY707TTJRHFUVxREmxKOoV4LAFsvuEmq8nsN/8oKCISLOs6NE
LCC2cx69kFd2jk4fCo8OI0nE3jK3kFzFniNIb1KQO9F2uRm78V2Q3WAuO5y52yitbBE/qSLr8RDE
bWNNNG7V/vp3uIlWzHeysl5NQnphEPCyL7DMZ+aTForgcAUbc/XnVFcWMQafbfj9aOH5rvRdcH8U
jxGG9zxxnJfvkdmh7Gn9hHeCLS0+q0DnGfeNuX//cpMkQNv16+tGMbdkcfp7zWfjh7vrx2JwvVEJ
uFYhOGyO4C4zcEMPZCCPyCqGk9Y6yLWbDQd9NQMw8V13fXw+5jHtRj/plivDL/bGnE2G48s0KfuS
YX2DN2gGd8/ZpTXF4JC5fMnmWLqkkSXWYvbuGql+ZmH+dLhS0G7TqN25QB8YC0G4AZ5IlkMZRpkN
hAtKNSpaNtYD6XsgzE7w36fdeuH6LYLbX4Lpw2MPdsMlt3EcsFUGuI/XW3sLSsTYsR1TiUZmGqgW
XbWDhoo6upspbRwzsOw4TGmxgUWX88ArNXDbA0bwoEDBKrE8vJLXtAKZsoEr7OeHTE9YbHz/TRQq
QL0yVRu8pFnZYpMqpiCn1HQ/RIApGmDm6d1QxzkdJq75rk2pdMnVVOd5ZlPKaQKHtIBOFjnmr2Pe
2BqOJ+TG9xx3HIL4KO4GRO843It+YegXWvsvEr+wNR6UaW1AEyTbOPJCrOzVVTTivsLUk7irEWZH
YRx3055cypHrCXZGne1MCC2QkkRKy5ofhmsegbvxXemUrYmVKzycN8L8S1C9usQARgDNhD+ROobS
KJiSTBuZrzfGO7cTKA7u9s8gPJcsadphUFszB3mqS/4YWGTMnCEyGBqKUhths7bAbeRV3+pwEmf3
JLN50fhgIOuJcapb4F0ia4bAuGnpQLx2YuIpj2MLV//LqdDvZyr69zMV4/uZSuvdVI6Gp6rAfbka
DsDSzwwk0BWyM1J/XLv0N24Cgy5lHTQ8kShcJY7C1rV8XxSlUpyhSUjaW3leF1uxp93g4/cdZZqW
z97K2w1pzxrL2V3sf3EKiLvr3u1oVKXpdPqvk9pxx0ezU+M1iYQVWmSy8fr3dUNt1P4Lbt9Chthj
AAA=

--Boundary-00=_r/brHbjCmz0O9Oc--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0CJPlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:41:22 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:36863 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab0CJPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lQcTkVag/rMQqXCBALBcGK3/ZAVfA2pkwHq54XMhpr2RIlUyFQUXINB+2EBieuSA6d
         TBai0NRUduTgIBTt7gK3u2GnbuiFPzCiM05nCdJX+TzsEiQrkPCkPN8mUHz0jzr3gDDY
         1mJZfeqUXvOztiE42suMZSUqYXcV7nzqbaU1Q=
MIME-Version: 1.0
In-Reply-To: <4B97AD5B.5080802@garzik.org>
References: <40a4ed591003100208v67b61ca5sd7a3ab8da99e975e@mail.gmail.com>
	 <4B97AD5B.5080802@garzik.org>
Date: Wed, 10 Mar 2010 16:41:18 +0100
Message-ID: <40a4ed591003100741i3f62c180k99fc85b2c57ab210@mail.gmail.com>
Subject: Re: ata1 timeouts on 2.6.34-rc1
From: Zeno Davatz <zdavatz@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cdfcf201f8df30481742172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cdfcf201f8df30481742172
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 10, 2010 at 3:31 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 03/10/2010 05:08 AM, Zeno Davatz wrote:
>>
>> I am also on an Intel SSD (160 GB). Every timeout blocks my PC for some
>> seconds.
>
>
> PLEASE provide full information standard to any bug report. =A0Just posti=
ng
> that you have a timeout tells us nothing about the hardware involved.
>
> lspci and full dmesg output is needed, at a minimum.

lspci:

00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory
Controller Hub (rev 0e)
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL
Integrated Graphics Controller (rev 0e)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 05)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 05)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 05)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 05)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 05)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d5)
00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC
Interface Bridge (rev 05)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 05)
00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA
Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 05)
02:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
02:06.0 Ethernet controller: Intel Corporation 82541GI Gigabit
Ethernet Controller (rev 05)

/var/log/messages

Mar 10 13:30:01 zenogentoo cron[12528]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 10 13:33:32 zenogentoo sudo:     zeno : TTY=3Dpts/0 ; PWD=3D/home/zeno
; USER=3Droot ; COMMAND=3D/usr/bin/emerge --sync
Mar 10 13:33:48 zenogentoo ata1: clearing spurious IRQ
Mar 10 13:34:19 zenogentoo ata1: lost interrupt (Status 0x50)
Mar 10 13:34:19 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
Mar 10 13:34:19 zenogentoo ata1.00: failed command: READ DMA
Mar 10 13:34:19 zenogentoo ata1.00: cmd
c8/00:08:d5:20:cb/00:00:00:00:00/e9 tag 0 dma 4096 in
Mar 10 13:34:19 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
Emask 0x4 (timeout)
Mar 10 13:34:19 zenogentoo ata1.00: status: { DRDY }
Mar 10 13:34:19 zenogentoo ata1: soft resetting link
Mar 10 13:34:19 zenogentoo ata1.00: configured for UDMA/133
Mar 10 13:34:19 zenogentoo ata1.00: device reported invalid CHS sector 0
Mar 10 13:34:19 zenogentoo ata1: EH complete
Mar 10 13:35:55 zenogentoo ata1: clearing spurious IRQ
Mar 10 13:36:26 zenogentoo ata1: lost interrupt (Status 0x50)
Mar 10 13:36:26 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
Mar 10 13:36:26 zenogentoo ata1.00: failed command: WRITE DMA
Mar 10 13:36:26 zenogentoo ata1.00: cmd
ca/00:10:1d:ad:52/00:00:00:00:00/e6 tag 0 dma 8192 out
Mar 10 13:36:26 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
Emask 0x4 (timeout)
Mar 10 13:36:26 zenogentoo ata1.00: status: { DRDY }
Mar 10 13:36:26 zenogentoo ata1: soft resetting link
Mar 10 13:36:26 zenogentoo ata1.00: configured for UDMA/133
Mar 10 13:36:26 zenogentoo ata1.00: device reported invalid CHS sector 0
Mar 10 13:36:26 zenogentoo ata1: EH complete
Mar 10 13:40:01 zenogentoo cron[12707]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 10 13:48:05 zenogentoo sudo:     zeno : TTY=3Dpts/0 ; PWD=3D/home/zeno
; USER=3Droot ; COMMAND=3D/usr/bin/emerge portage
Mar 10 13:49:22 zenogentoo ata1: clearing spurious IRQ
Mar 10 13:49:53 zenogentoo ata1: lost interrupt (Status 0x50)
Mar 10 13:49:53 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
Mar 10 13:49:53 zenogentoo ata1.00: failed command: WRITE DMA
Mar 10 13:49:53 zenogentoo ata1.00: cmd
ca/00:08:05:21:df/00:00:00:00:00/ef tag 0 dma 4096 out
Mar 10 13:49:53 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
Emask 0x4 (timeout)
Mar 10 13:49:53 zenogentoo ata1.00: status: { DRDY }
Mar 10 13:49:53 zenogentoo ata1: soft resetting link
Mar 10 13:49:53 zenogentoo ata1.00: configured for UDMA/133
Mar 10 13:49:53 zenogentoo ata1.00: device reported invalid CHS sector 0
Mar 10 13:49:53 zenogentoo ata1: EH complete

Let me know if I can supply you with anymore information. Also see
attached lspci-v file.

Best
Zeno

--000e0cdfcf201f8df30481742172
Content-Type: application/octet-stream; name=lspci-v
Content-Disposition: attachment; filename=lspci-v
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6mar3mi0

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI5MTVHL1AvR1YvR0wvUEwv
OTEwR0wgTWVtb3J5IENvbnRyb2xsZXIgSHViIChyZXYgMGUpCglTdWJzeXN0ZW06IE1pY3JvLVN0
YXIgSW50ZXJuYXRpb25hbCBDby4sIEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1
cyBtYXN0ZXIsIGZhc3QgZGV2c2VsLCBsYXRlbmN5IDAKCUNhcGFiaWxpdGllczogW2UwXSBWZW5k
b3IgU3BlY2lmaWMgSW5mb3JtYXRpb24gPD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTogYWdwZ2Fy
dC1pbnRlbAoKMDA6MDIuMCBWR0EgY29tcGF0aWJsZSBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3Jh
dGlvbiA4MjkxNUcvR1YvOTEwR0wgSW50ZWdyYXRlZCBHcmFwaGljcyBDb250cm9sbGVyIChyZXYg
MGUpIChwcm9nLWlmIDAwIFtWR0EgY29udHJvbGxlcl0pCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIg
SW50ZXJuYXRpb25hbCBDby4sIEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1cyBt
YXN0ZXIsIGZhc3QgZGV2c2VsLCBsYXRlbmN5IDAsIElSUSAxNgoJTWVtb3J5IGF0IGZiZTgwMDAw
ICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTUxMktdCglJL08gcG9ydHMgYXQgZGMw
MCBbc2l6ZT04XQoJTWVtb3J5IGF0IGQwMDAwMDAwICgzMi1iaXQsIHByZWZldGNoYWJsZSkgW3Np
emU9MjU2TV0KCU1lbW9yeSBhdCBmYmU0MDAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT0yNTZLXQoJQ2FwYWJpbGl0aWVzOiBbZDBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAy
CglLZXJuZWwgZHJpdmVyIGluIHVzZTogaTkxNQoKMDA6MWIuMCBBdWRpbyBkZXZpY2U6IEludGVs
IENvcnBvcmF0aW9uIDgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIEhpZ2ggRGVm
aW5pdGlvbiBBdWRpbyBDb250cm9sbGVyIChyZXYgMDUpCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIg
SW50ZXJuYXRpb25hbCBDby4sIEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1cyBt
YXN0ZXIsIGZhc3QgZGV2c2VsLCBsYXRlbmN5IDAsIElSUSAxMAoJTWVtb3J5IGF0IGZiZTM4MDAw
ICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCUNhcGFiaWxpdGllczogWzUw
XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJQ2FwYWJpbGl0aWVzOiBbNjBdIE1lc3NhZ2Ug
U2lnbmFsbGVkIEludGVycnVwdHM6IE1hc2stIDY0Yml0KyBRdWV1ZT0wLzAgRW5hYmxlLQoJQ2Fw
YWJpbGl0aWVzOiBbNzBdIEV4cHJlc3MgUm9vdCBDb21wbGV4IEludGVncmF0ZWQgRW5kcG9pbnQs
IE1TSSAwMAoJQ2FwYWJpbGl0aWVzOiBbMTAwXSBWaXJ0dWFsIENoYW5uZWwgPD8+CglDYXBhYmls
aXRpZXM6IFsxMzBdIFJvb3QgQ29tcGxleCBMaW5rIDw/PgoKMDA6MWQuMCBVU0IgQ29udHJvbGxl
cjogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFGQi9GQk0vRlIvRlcvRlJXIChJQ0g2IEZhbWlseSkg
VVNCIFVIQ0kgIzEgKHJldiAwNSkgKHByb2ctaWYgMDAgW1VIQ0ldKQoJU3Vic3lzdGVtOiBNaWNy
by1TdGFyIEludGVybmF0aW9uYWwgQ28uLCBMdGQuIFVua25vd24gZGV2aWNlIDEzNzAKCUZsYWdz
OiBidXMgbWFzdGVyLCBtZWRpdW0gZGV2c2VsLCBsYXRlbmN5IDAsIElSUSAyMwoJSS9PIHBvcnRz
IGF0IGQ4ODAgW3NpemU9MzJdCglLZXJuZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QKCjAwOjFk
LjEgVVNCIENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRkIvRkJNL0ZSL0ZXL0ZS
VyAoSUNINiBGYW1pbHkpIFVTQiBVSENJICMyIChyZXYgMDUpIChwcm9nLWlmIDAwIFtVSENJXSkK
CVN1YnN5c3RlbTogTWljcm8tU3RhciBJbnRlcm5hdGlvbmFsIENvLiwgTHRkLiBVbmtub3duIGRl
dmljZSAxMzcwCglGbGFnczogYnVzIG1hc3RlciwgbWVkaXVtIGRldnNlbCwgbGF0ZW5jeSAwLCBJ
UlEgMTkKCUkvTyBwb3J0cyBhdCBkODAwIFtzaXplPTMyXQoJS2VybmVsIGRyaXZlciBpbiB1c2U6
IHVoY2lfaGNkCgowMDoxZC4yIFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4Mjgw
MUZCL0ZCTS9GUi9GVy9GUlcgKElDSDYgRmFtaWx5KSBVU0IgVUhDSSAjMyAocmV2IDA1KSAocHJv
Zy1pZiAwMCBbVUhDSV0pCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIgSW50ZXJuYXRpb25hbCBDby4s
IEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1cyBtYXN0ZXIsIG1lZGl1bSBkZXZz
ZWwsIGxhdGVuY3kgMCwgSVJRIDE4CglJL08gcG9ydHMgYXQgZDQ4MCBbc2l6ZT0zMl0KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiB1aGNpX2hjZAoKMDA6MWQuMyBVU0IgQ29udHJvbGxlcjogSW50ZWwg
Q29ycG9yYXRpb24gODI4MDFGQi9GQk0vRlIvRlcvRlJXIChJQ0g2IEZhbWlseSkgVVNCIFVIQ0kg
IzQgKHJldiAwNSkgKHByb2ctaWYgMDAgW1VIQ0ldKQoJU3Vic3lzdGVtOiBNaWNyby1TdGFyIElu
dGVybmF0aW9uYWwgQ28uLCBMdGQuIFVua25vd24gZGV2aWNlIDEzNzAKCUZsYWdzOiBidXMgbWFz
dGVyLCBtZWRpdW0gZGV2c2VsLCBsYXRlbmN5IDAsIElSUSAxNgoJSS9PIHBvcnRzIGF0IGQ0MDAg
W3NpemU9MzJdCglLZXJuZWwgZHJpdmVyIGluIHVzZTogdWhjaV9oY2QKCjAwOjFkLjcgVVNCIENv
bnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBG
YW1pbHkpIFVTQjIgRUhDSSBDb250cm9sbGVyIChyZXYgMDUpIChwcm9nLWlmIDIwIFtFSENJXSkK
CVN1YnN5c3RlbTogTWljcm8tU3RhciBJbnRlcm5hdGlvbmFsIENvLiwgTHRkLiBVbmtub3duIGRl
dmljZSAxMzcwCglGbGFnczogYnVzIG1hc3RlciwgbWVkaXVtIGRldnNlbCwgbGF0ZW5jeSAwLCBJ
UlEgMjMKCU1lbW9yeSBhdCBmYmUzN2MwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6
ZT0xS10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJQ2Fw
YWJpbGl0aWVzOiBbNThdIERlYnVnIHBvcnQ6IEJBUj0xIG9mZnNldD0wMGEwCglLZXJuZWwgZHJp
dmVyIGluIHVzZTogZWhjaV9oY2QKCjAwOjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRp
b24gODI4MDEgUENJIEJyaWRnZSAocmV2IGQ1KSAocHJvZy1pZiAwMSBbU3VidHJhY3RpdmUgZGVj
b2RlXSkKCUZsYWdzOiBidXMgbWFzdGVyLCBmYXN0IGRldnNlbCwgbGF0ZW5jeSAwCglCdXM6IHBy
aW1hcnk9MDAsIHNlY29uZGFyeT0wMiwgc3Vib3JkaW5hdGU9MDIsIHNlYy1sYXRlbmN5PTMyCglJ
L08gYmVoaW5kIGJyaWRnZTogMDAwMGUwMDAtMDAwMGVmZmYKCU1lbW9yeSBiZWhpbmQgYnJpZGdl
OiBmYmYwMDAwMC1mYmZmZmZmZgoJQ2FwYWJpbGl0aWVzOiBbNTBdIFN1YnN5c3RlbTogTWljcm8t
U3RhciBJbnRlcm5hdGlvbmFsIENvLiwgTHRkLiBVbmtub3duIGRldmljZSAxMzcwCgowMDoxZi4w
IElTQSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRkIvRlIgKElDSDYvSUNINlIpIExQ
QyBJbnRlcmZhY2UgQnJpZGdlIChyZXYgMDUpCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIgSW50ZXJu
YXRpb25hbCBDby4sIEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1cyBtYXN0ZXIs
IG1lZGl1bSBkZXZzZWwsIGxhdGVuY3kgMAoKMDA6MWYuMSBJREUgaW50ZXJmYWNlOiBJbnRlbCBD
b3Jwb3JhdGlvbiA4MjgwMUZCL0ZCTS9GUi9GVy9GUlcgKElDSDYgRmFtaWx5KSBJREUgQ29udHJv
bGxlciAocmV2IDA1KSAocHJvZy1pZiA4YSBbTWFzdGVyIFNlY1AgUHJpUF0pCglTdWJzeXN0ZW06
IE1pY3JvLVN0YXIgSW50ZXJuYXRpb25hbCBDby4sIEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJ
RmxhZ3M6IGJ1cyBtYXN0ZXIsIG1lZGl1bSBkZXZzZWwsIGxhdGVuY3kgMCwgSVJRIDE4CglJL08g
cG9ydHMgYXQgMDFmMCBbc2l6ZT04XQoJSS9PIHBvcnRzIGF0IDAzZjQgW3NpemU9MV0KCUkvTyBw
b3J0cyBhdCAwMTcwIFtzaXplPThdCglJL08gcG9ydHMgYXQgMDM3NCBbc2l6ZT0xXQoJSS9PIHBv
cnRzIGF0IGZmYTAgW3NpemU9MTZdCglLZXJuZWwgZHJpdmVyIGluIHVzZTogUElJWF9JREUKCjAw
OjFmLjIgSURFIGludGVyZmFjZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFGQi9GVyAoSUNINi9J
Q0g2VykgU0FUQSBDb250cm9sbGVyIChyZXYgMDUpIChwcm9nLWlmIDhmIFtNYXN0ZXIgU2VjUCBT
ZWNPIFByaVAgUHJpT10pCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIgSW50ZXJuYXRpb25hbCBDby4s
IEx0ZC4gVW5rbm93biBkZXZpY2UgMTM3MAoJRmxhZ3M6IGJ1cyBtYXN0ZXIsIDY2TUh6LCBtZWRp
dW0gZGV2c2VsLCBsYXRlbmN5IDAsIElSUSAxOQoJSS9PIHBvcnRzIGF0IGQwODAgW3NpemU9OF0K
CUkvTyBwb3J0cyBhdCBkMDAwIFtzaXplPTRdCglJL08gcG9ydHMgYXQgY2MwMCBbc2l6ZT04XQoJ
SS9PIHBvcnRzIGF0IGM4ODAgW3NpemU9NF0KCUkvTyBwb3J0cyBhdCBjODAwIFtzaXplPTE2XQoJ
Q2FwYWJpbGl0aWVzOiBbNzBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCglLZXJuZWwgZHJp
dmVyIGluIHVzZTogYXRhX3BpaXgKCjAwOjFmLjMgU01CdXM6IEludGVsIENvcnBvcmF0aW9uIDgy
ODAxRkIvRkJNL0ZSL0ZXL0ZSVyAoSUNINiBGYW1pbHkpIFNNQnVzIENvbnRyb2xsZXIgKHJldiAw
NSkKCVN1YnN5c3RlbTogTWljcm8tU3RhciBJbnRlcm5hdGlvbmFsIENvLiwgTHRkLiBVbmtub3du
IGRldmljZSAxMzcwCglGbGFnczogbWVkaXVtIGRldnNlbCwgSVJRIDEwCglJL08gcG9ydHMgYXQg
MDQwMCBbc2l6ZT0zMl0KCjAyOjAzLjAgRmlyZVdpcmUgKElFRUUgMTM5NCk6IFZJQSBUZWNobm9s
b2dpZXMsIEluYy4gSUVFRSAxMzk0IEhvc3QgQ29udHJvbGxlciAocmV2IDgwKSAocHJvZy1pZiAx
MCBbT0hDSV0pCglTdWJzeXN0ZW06IE1pY3JvLVN0YXIgSW50ZXJuYXRpb25hbCBDby4sIEx0ZC4g
VW5rbm93biBkZXZpY2UgMDEyMgoJRmxhZ3M6IGJ1cyBtYXN0ZXIsIG1lZGl1bSBkZXZzZWwsIGxh
dGVuY3kgNjQsIElSUSAxOQoJTWVtb3J5IGF0IGZiZmZmODAwICgzMi1iaXQsIG5vbi1wcmVmZXRj
aGFibGUpIFtzaXplPTJLXQoJSS9PIHBvcnRzIGF0IGVjMDAgW3NpemU9MTI4XQoJQ2FwYWJpbGl0
aWVzOiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCglLZXJuZWwgZHJpdmVyIGluIHVz
ZTogb2hjaTEzOTQKCjAyOjA2LjAgRXRoZXJuZXQgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRp
b24gODI1NDFHSSBHaWdhYml0IEV0aGVybmV0IENvbnRyb2xsZXIgKHJldiAwNSkKCVN1YnN5c3Rl
bTogTWljcm8tU3RhciBJbnRlcm5hdGlvbmFsIENvLiwgTHRkLiBVbmtub3duIGRldmljZSA4MjJj
CglGbGFnczogYnVzIG1hc3RlciwgNjZNSHosIG1lZGl1bSBkZXZzZWwsIGxhdGVuY3kgNjQsIElS
USAxOAoJTWVtb3J5IGF0IGZiZmMwMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXpl
PTEyOEtdCglNZW1vcnkgYXQgZmJmYTAwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3Np
emU9MTI4S10KCUkvTyBwb3J0cyBhdCBlODgwIFtzaXplPTY0XQoJRXhwYW5zaW9uIFJPTSBhdCBm
YmY4MDAwMCBbZGlzYWJsZWRdIFtzaXplPTEyOEtdCglDYXBhYmlsaXRpZXM6IFtkY10gUG93ZXIg
TWFuYWdlbWVudCB2ZXJzaW9uIDIKCUNhcGFiaWxpdGllczogW2U0XSBQQ0ktWCBub24tYnJpZGdl
IGRldmljZQoJQ2FwYWJpbGl0aWVzOiBbZjBdIE1lc3NhZ2UgU2lnbmFsbGVkIEludGVycnVwdHM6
IE1hc2stIDY0Yml0KyBRdWV1ZT0wLzAgRW5hYmxlLQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGUx
MDAwCgo=
--000e0cdfcf201f8df30481742172--

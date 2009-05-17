Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZEQM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZEQM1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZEQM1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:27:39 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:61966 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZEQM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pj2TgCCpL5DzIpnlGdEAMylyMyrlZh3dJethI5K0jSXkC1X+y+oNN/DNV7sZXD2v9j
         mwCn+Dm8vkj6cP/vUiT8eQUdRNGIdtdgMdaL5R46+4aR6ol0PEWRNksjKfu7S5cLwmrA
         ItbRTlT3mw7QRaAddtqHqZYjbQ+yCHGm0EwUE=
MIME-Version: 1.0
In-Reply-To: <20090517121711.GA3583@localhost>
References: <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	 <20090517011906.GA6375@localhost>
	 <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
	 <20090517020829.GB6809@localhost>
	 <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
	 <20090517045800.GA32723@localhost>
	 <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
	 <20090517093004.GA2635@localhost>
	 <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com>
	 <20090517121711.GA3583@localhost>
Date: Sun, 17 May 2009 17:57:39 +0530
Message-ID: <93655eb70905170527t490653dge6e25a9e3724a918@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636e91011add4ae046a1acdad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e91011add4ae046a1acdad
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

> The clear command can be a big clue. Can you try these commands in the
> terminal and show us the two log files?
>
> =A0 =A0 =A0 =A0strace -o all.log -T clear
> =A0 =A0 =A0 =A0strace -o sum.log -c clear
>
ok here go the logs :

"all.log"
execve("/usr/bin/clear", ["clear"], [/* 47 vars */]) =3D 0 <0.000432>
brk(0)                                  =3D 0x981e000 <0.000018>
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or
directory) <0.000026>
open("/etc/ld.so.cache", O_RDONLY)      =3D 3 <0.000027>
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D140850, ...}) =3D 0 <0.000019=
>
mmap2(NULL, 140850, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb7f01000 <0.000023>
close(3)                                =3D 0 <0.000018>
open("/lib/libtinfo.so.5", O_RDONLY)    =3D 3 <0.000043>
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\332\355\0074\0=
\0\0D"...,
512) =3D 512 <0.000028>
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D98036, ...}) =3D 0 <0.000020>
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb7f00000 <0.000021>
mmap2(0x7ed8000, 99928, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =3D 0x7ed8000 <0.000023>
mmap2(0x7eee000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15) =3D 0x7eee000 <0.000030>
close(3)                                =3D 0 <0.000018>
open("/lib/libc.so.6", O_RDONLY)        =3D 3 <0.000029>
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@xk\0004\0\0\0P"...=
,
512) =3D 512 <0.000021>
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1809672, ...}) =3D 0 <0.00001=
9>
mmap2(0x6a1000, 1521232, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =3D 0x6a1000 <0.000022>
mmap2(0x80f000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16e) =3D 0x80f000 <0.000032>
mmap2(0x812000, 9808, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x812000 <0.000026>
close(3)                                =3D 0 <0.000018>
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb7eff000 <0.000024>
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7eff6c0,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) =3D 0 <0.000019>
mprotect(0x80f000, 8192, PROT_READ)     =3D 0 <0.000026>
mprotect(0x69d000, 4096, PROT_READ)     =3D 0 <0.000023>
munmap(0xb7f01000, 140850)              =3D 0 <0.000032>
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo
...}) =3D 0 <0.000023>
brk(0)                                  =3D 0x981e000 <0.000019>
brk(0x983f000)                          =3D 0x983f000 <0.000022>
stat64("/root/.terminfo", 0xbfd20f24)   =3D -1 ENOENT (No such file or
directory) <0.000027>
stat64("/etc/terminfo", {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =3D =
0
<0.000025>
access("/etc/terminfo/x/xterm", R_OK)   =3D -1 ENOENT (No such file or
directory) <0.000026>
stat64("/usr/share/terminfo", {st_mode=3DS_IFDIR|0755, st_size=3D4096,
...}) =3D 0 <0.000026>
access("/usr/share/terminfo/x/xterm", R_OK) =3D 0 <0.000028>
open("/usr/share/terminfo/x/xterm", O_RDONLY|O_LARGEFILE) =3D 3 <0.000031>
read(3, "\32\0010\0&\0\17\0\235\1F\5xterm|xterm terminal "..., 4097) =3D
3220 <0.000035>
close(3)                                =3D 0 <0.000022>
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo
...}) =3D 0 <0.000025>
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo
...}) =3D 0 <0.000020>
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo
...}) =3D 0 <0.000021>
ioctl(1, TIOCGWINSZ, {ws_row=3D24, ws_col=3D80, ws_xpixel=3D0, ws_ypixel=3D=
0})
=3D 0 <0.000020>
fstat64(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 2), ...}) =3D 0 =
<0.000020>
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb7f23000 <0.000025>
write(1, "\33[H\33[2J"..., 7)           =3D 7 <0.000027>
exit_group(0)                           =3D ?

"sum.log"

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 93.27    0.000485         485         1           execve
  6.73    0.000035           7         5           ioctl
  0.00    0.000000           0         3           read
  0.00    0.000000           0         1           write
  0.00    0.000000           0         4           open
  0.00    0.000000           0         4           close
  0.00    0.000000           0         3         2 access
  0.00    0.000000           0         3           brk
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         2           mprotect
  0.00    0.000000           0         9           mmap2
  0.00    0.000000           0         3         1 stat64
  0.00    0.000000           0         4           fstat64
  0.00    0.000000           0         1           set_thread_area
------ ----------- ----------- --------- --------- ----------------
100.00    0.000520                    44         3 total

I have also attached the logs, in case that is more useful .

Cheers
Satish



--=20
http://satish.playdrupal.com

--001636e91011add4ae046a1acdad
Content-Type: application/octet-stream; name="all.log"
Content-Disposition: attachment; filename="all.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_futq2k5r0

ZXhlY3ZlKCIvdXNyL2Jpbi9jbGVhciIsIFsiY2xlYXIiXSwgWy8qIDQ3IHZhcnMgKi9dKSA9IDAg
PDAuMDAwNDMyPgpicmsoMCkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDk4
MWUwMDAgPDAuMDAwMDE4PgphY2Nlc3MoIi9ldGMvbGQuc28ucHJlbG9hZCIsIFJfT0spICAgICAg
PSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpIDwwLjAwMDAyNj4Kb3Blbigi
L2V0Yy9sZC5zby5jYWNoZSIsIE9fUkRPTkxZKSAgICAgID0gMyA8MC4wMDAwMjc+CmZzdGF0NjQo
Mywge3N0X21vZGU9U19JRlJFR3wwNjQ0LCBzdF9zaXplPTE0MDg1MCwgLi4ufSkgPSAwIDwwLjAw
MDAxOT4KbW1hcDIoTlVMTCwgMTQwODUwLCBQUk9UX1JFQUQsIE1BUF9QUklWQVRFLCAzLCAwKSA9
IDB4YjdmMDEwMDAgPDAuMDAwMDIzPgpjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgPSAwIDwwLjAwMDAxOD4Kb3BlbigiL2xpYi9saWJ0aW5mby5zby41IiwgT19SRE9OTFkp
ICAgID0gMyA8MC4wMDAwNDM+CnJlYWQoMywgIlwxNzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBcMFww
XDBcM1wwXDNcMFwxXDBcMFwwXDM0MFwzMzJcMzU1XDAwNzRcMFwwXDBEIi4uLiwgNTEyKSA9IDUx
MiA8MC4wMDAwMjg+CmZzdGF0NjQoMywge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTk4
MDM2LCAuLi59KSA9IDAgPDAuMDAwMDIwPgptbWFwMihOVUxMLCA0MDk2LCBQUk9UX1JFQUR8UFJP
VF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9VUywgLTEsIDApID0gMHhiN2YwMDAwMCA8
MC4wMDAwMjE+Cm1tYXAyKDB4N2VkODAwMCwgOTk5MjgsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1B
UF9QUklWQVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg3ZWQ4MDAwIDwwLjAwMDAyMz4KbW1h
cDIoMHg3ZWVlMDAwLCAxMjI4OCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1B
UF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDE1KSA9IDB4N2VlZTAwMCA8MC4wMDAwMzA+CmNs
b3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAgPDAuMDAwMDE4PgpvcGVu
KCIvbGliL2xpYmMuc28uNiIsIE9fUkRPTkxZKSAgICAgICAgPSAzIDwwLjAwMDAyOT4KcmVhZCgz
LCAiXDE3N0VMRlwxXDFcMVwwXDBcMFwwXDBcMFwwXDBcMFwzXDBcM1wwXDFcMFwwXDBAeGtcMDAw
NFwwXDBcMFAiLi4uLCA1MTIpID0gNTEyIDwwLjAwMDAyMT4KZnN0YXQ2NCgzLCB7c3RfbW9kZT1T
X0lGUkVHfDA3NTUsIHN0X3NpemU9MTgwOTY3MiwgLi4ufSkgPSAwIDwwLjAwMDAxOT4KbW1hcDIo
MHg2YTEwMDAsIDE1MjEyMzIsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1BUF9QUklWQVRFfE1BUF9E
RU5ZV1JJVEUsIDMsIDApID0gMHg2YTEwMDAgPDAuMDAwMDIyPgptbWFwMigweDgwZjAwMCwgMTIy
ODgsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0RFTllX
UklURSwgMywgMHgxNmUpID0gMHg4MGYwMDAgPDAuMDAwMDMyPgptbWFwMigweDgxMjAwMCwgOTgw
OCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfQU5PTllN
T1VTLCAtMSwgMCkgPSAweDgxMjAwMCA8MC4wMDAwMjY+CmNsb3NlKDMpICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICA9IDAgPDAuMDAwMDE4PgptbWFwMihOVUxMLCA0MDk2LCBQUk9UX1JF
QUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9VUywgLTEsIDApID0gMHhiN2Vm
ZjAwMCA8MC4wMDAwMjQ+CnNldF90aHJlYWRfYXJlYSh7ZW50cnlfbnVtYmVyOi0xIC0+IDYsIGJh
c2VfYWRkcjoweGI3ZWZmNmMwLCBsaW1pdDoxMDQ4NTc1LCBzZWdfMzJiaXQ6MSwgY29udGVudHM6
MCwgcmVhZF9leGVjX29ubHk6MCwgbGltaXRfaW5fcGFnZXM6MSwgc2VnX25vdF9wcmVzZW50OjAs
IHVzZWFibGU6MX0pID0gMCA8MC4wMDAwMTk+Cm1wcm90ZWN0KDB4ODBmMDAwLCA4MTkyLCBQUk9U
X1JFQUQpICAgICA9IDAgPDAuMDAwMDI2PgptcHJvdGVjdCgweDY5ZDAwMCwgNDA5NiwgUFJPVF9S
RUFEKSAgICAgPSAwIDwwLjAwMDAyMz4KbXVubWFwKDB4YjdmMDEwMDAsIDE0MDg1MCkgICAgICAg
ICAgICAgID0gMCA8MC4wMDAwMzI+CmlvY3RsKDEsIFNORENUTF9UTVJfVElNRUJBU0Ugb3IgVENH
RVRTLCB7QjM4NDAwIG9wb3N0IGlzaWcgaWNhbm9uIGVjaG8gLi4ufSkgPSAwIDwwLjAwMDAyMz4K
YnJrKDApICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gMHg5ODFlMDAwIDwwLjAw
MDAxOT4KYnJrKDB4OTgzZjAwMCkgICAgICAgICAgICAgICAgICAgICAgICAgID0gMHg5ODNmMDAw
IDwwLjAwMDAyMj4Kc3RhdDY0KCIvcm9vdC8udGVybWluZm8iLCAweGJmZDIwZjI0KSAgID0gLTEg
RU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KSA8MC4wMDAwMjc+CnN0YXQ2NCgiL2V0
Yy90ZXJtaW5mbyIsIHtzdF9tb2RlPVNfSUZESVJ8MDc1NSwgc3Rfc2l6ZT00MDk2LCAuLi59KSA9
IDAgPDAuMDAwMDI1PgphY2Nlc3MoIi9ldGMvdGVybWluZm8veC94dGVybSIsIFJfT0spICAgPSAt
MSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpIDwwLjAwMDAyNj4Kc3RhdDY0KCIv
dXNyL3NoYXJlL3Rlcm1pbmZvIiwge3N0X21vZGU9U19JRkRJUnwwNzU1LCBzdF9zaXplPTQwOTYs
IC4uLn0pID0gMCA8MC4wMDAwMjY+CmFjY2VzcygiL3Vzci9zaGFyZS90ZXJtaW5mby94L3h0ZXJt
IiwgUl9PSykgPSAwIDwwLjAwMDAyOD4Kb3BlbigiL3Vzci9zaGFyZS90ZXJtaW5mby94L3h0ZXJt
IiwgT19SRE9OTFl8T19MQVJHRUZJTEUpID0gMyA8MC4wMDAwMzE+CnJlYWQoMywgIlwzMlwwMDEw
XDAmXDBcMTdcMFwyMzVcMUZcNXh0ZXJtfHh0ZXJtIHRlcm1pbmFsICIuLi4sIDQwOTcpID0gMzIy
MCA8MC4wMDAwMzU+CmNsb3NlKDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAg
PDAuMDAwMDIyPgppb2N0bCgxLCBTTkRDVExfVE1SX1RJTUVCQVNFIG9yIFRDR0VUUywge0IzODQw
MCBvcG9zdCBpc2lnIGljYW5vbiBlY2hvIC4uLn0pID0gMCA8MC4wMDAwMjU+CmlvY3RsKDEsIFNO
RENUTF9UTVJfVElNRUJBU0Ugb3IgVENHRVRTLCB7QjM4NDAwIG9wb3N0IGlzaWcgaWNhbm9uIGVj
aG8gLi4ufSkgPSAwIDwwLjAwMDAyMD4KaW9jdGwoMSwgU05EQ1RMX1RNUl9USU1FQkFTRSBvciBU
Q0dFVFMsIHtCMzg0MDAgb3Bvc3QgaXNpZyBpY2Fub24gZWNobyAuLi59KSA9IDAgPDAuMDAwMDIx
Pgppb2N0bCgxLCBUSU9DR1dJTlNaLCB7d3Nfcm93PTI0LCB3c19jb2w9ODAsIHdzX3hwaXhlbD0w
LCB3c195cGl4ZWw9MH0pID0gMCA8MC4wMDAwMjA+CmZzdGF0NjQoMSwge3N0X21vZGU9U19JRkNI
UnwwNjIwLCBzdF9yZGV2PW1ha2VkZXYoMTM2LCAyKSwgLi4ufSkgPSAwIDwwLjAwMDAyMD4KbW1h
cDIoTlVMTCwgNDA5NiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9BTk9O
WU1PVVMsIC0xLCAwKSA9IDB4YjdmMjMwMDAgPDAuMDAwMDI1Pgp3cml0ZSgxLCAiXDMzW0hcMzNb
MkoiLi4uLCA3KSAgICAgICAgICAgPSA3IDwwLjAwMDAyNz4KZXhpdF9ncm91cCgwKSAgICAgICAg
ICAgICAgICAgICAgICAgICAgID0gPwo=
--001636e91011add4ae046a1acdad
Content-Type: application/octet-stream; name="sum.log"
Content-Disposition: attachment; filename="sum.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_futq2r4r1

JSB0aW1lICAgICBzZWNvbmRzICB1c2Vjcy9jYWxsICAgICBjYWxscyAgICBlcnJvcnMgc3lzY2Fs
bAotLS0tLS0gLS0tLS0tLS0tLS0gLS0tLS0tLS0tLS0gLS0tLS0tLS0tIC0tLS0tLS0tLSAtLS0t
LS0tLS0tLS0tLS0tCiA5My4yNyAgICAwLjAwMDQ4NSAgICAgICAgIDQ4NSAgICAgICAgIDEgICAg
ICAgICAgIGV4ZWN2ZQogIDYuNzMgICAgMC4wMDAwMzUgICAgICAgICAgIDcgICAgICAgICA1ICAg
ICAgICAgICBpb2N0bAogIDAuMDAgICAgMC4wMDAwMDAgICAgICAgICAgIDAgICAgICAgICAzICAg
ICAgICAgICByZWFkCiAgMC4wMCAgICAwLjAwMDAwMCAgICAgICAgICAgMCAgICAgICAgIDEgICAg
ICAgICAgIHdyaXRlCiAgMC4wMCAgICAwLjAwMDAwMCAgICAgICAgICAgMCAgICAgICAgIDQgICAg
ICAgICAgIG9wZW4KICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAgNCAgICAg
ICAgICAgY2xvc2UKICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAgMyAgICAg
ICAgIDIgYWNjZXNzCiAgMC4wMCAgICAwLjAwMDAwMCAgICAgICAgICAgMCAgICAgICAgIDMgICAg
ICAgICAgIGJyawogIDAuMDAgICAgMC4wMDAwMDAgICAgICAgICAgIDAgICAgICAgICAxICAgICAg
ICAgICBtdW5tYXAKICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAgMiAgICAg
ICAgICAgbXByb3RlY3QKICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAgOSAg
ICAgICAgICAgbW1hcDIKICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAgMyAg
ICAgICAgIDEgc3RhdDY0CiAgMC4wMCAgICAwLjAwMDAwMCAgICAgICAgICAgMCAgICAgICAgIDQg
ICAgICAgICAgIGZzdGF0NjQKICAwLjAwICAgIDAuMDAwMDAwICAgICAgICAgICAwICAgICAgICAg
MSAgICAgICAgICAgc2V0X3RocmVhZF9hcmVhCi0tLS0tLSAtLS0tLS0tLS0tLSAtLS0tLS0tLS0t
LSAtLS0tLS0tLS0gLS0tLS0tLS0tIC0tLS0tLS0tLS0tLS0tLS0KMTAwLjAwICAgIDAuMDAwNTIw
ICAgICAgICAgICAgICAgICAgICA0NCAgICAgICAgIDMgdG90YWwK
--001636e91011add4ae046a1acdad--

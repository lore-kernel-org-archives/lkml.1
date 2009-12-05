Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZLEOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZLEOmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZLEOmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:42:00 -0500
Received: from mail-px0-f173.google.com ([209.85.216.173]:49772 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZLEOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IKvRtJZJnLrRtHmiDl98QJdIftb3LMtMa4OANBHY9zHPw1j4aDBbKFreMTtHGmEH7k
         L2uohqHP/Cb5JBy37c+uHcgTTdsHtQNJfMM4tMD37+cgXfiU2RkpSmQJeqQ+N1DUSaN7
         Hq8UO1vXOzXkQ7bIoQHgk5Ynd0S1dAxj82Kik=
MIME-Version: 1.0
In-Reply-To: <4B1A6F78.8010408@myrealbox.com>
References: <c1f41c620912042148n7d3f6f29h713a2d44369a5810@mail.gmail.com>
	 <4B1A6F78.8010408@myrealbox.com>
Date: Sat, 5 Dec 2009 21:42:06 +0700
Message-ID: <c1f41c620912050642v72078ac1w839809fcdcbe5bf3@mail.gmail.com>
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, jbarnes@virtuousgeek.org,
       intel-gfx@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=001636417d1373ed010479fc3a22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636417d1373ed010479fc3a22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 5, 2009 at 9:34 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
> Emmanuel Benisty wrote:
>> I just wanted to report 2 regressions I am having now with 2.6.32.
>>
>> Video
>> Screen is flickering/glitching like crazy in X. It happens whether
>> randomly or when conky is refreshed, when the mouse cursor moves and
>> like hell when a page is loading in the browser. Not so easy to
>> describe this issue.
>> Xorg.0.log is attached.
>> (I've uploaded an utterly crappy mobile phone video if needed but I
>> doubt this could be of any help, anyway, it's here
>> http://omploader.org/vMngzcA/Xorg.tar.bz2 )
>
> That sounds like FIFO underruns, which (I think) were introduced when
> self-refresh was enabled but should have been fixed. =C2=A0I personally h=
ave no
> clue how to fix them, but if you told the Intel people what kind of chip =
you
> have (lspci output), they can probably fix it. =C2=A0(cc added)

Thanks for your reply Andy. lspci output is attached.

--001636417d1373ed010479fc3a22
Content-Type: text/plain; charset=US-ASCII; name="lspci.txt"
Content-Disposition: attachment; filename="lspci.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2uhqgk20

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gTW9iaWxlIFBNOTY1L0dNOTY1
L0dMOTYwIE1lbW9yeSBDb250cm9sbGVyIEh1YiAocmV2IDAzKQowMDowMi4wIFZHQSBjb21wYXRp
YmxlIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIE1vYmlsZSBHTTk2NS9HTDk2MCBJbnRl
Z3JhdGVkIEdyYXBoaWNzIENvbnRyb2xsZXIgKHJldiAwMykKMDA6MDIuMSBEaXNwbGF5IGNvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIE1vYmlsZSBHTTk2NS9HTDk2MCBJbnRlZ3JhdGVkIEdy
YXBoaWNzIENvbnRyb2xsZXIgKHJldiAwMykKMDA6MWEuMCBVU0IgQ29udHJvbGxlcjogSW50ZWwg
Q29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjNCAo
cmV2IDAzKQowMDoxYS4xIFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUgg
KElDSDggRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICM1IChyZXYgMDMpCjAwOjFhLjcgVVNC
IENvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFVTQjIg
RUhDSSBDb250cm9sbGVyICMyIChyZXYgMDMpCjAwOjFiLjAgQXVkaW8gZGV2aWNlOiBJbnRlbCBD
b3Jwb3JhdGlvbiA4MjgwMUggKElDSDggRmFtaWx5KSBIRCBBdWRpbyBDb250cm9sbGVyIChyZXYg
MDMpCjAwOjFjLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZh
bWlseSkgUENJIEV4cHJlc3MgUG9ydCAxIChyZXYgMDMpCjAwOjFjLjEgUENJIGJyaWRnZTogSW50
ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCAyIChy
ZXYgMDMpCjAwOjFjLjIgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4
IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCAzIChyZXYgMDMpCjAwOjFjLjMgUENJIGJyaWRnZTog
SW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCA0
IChyZXYgMDMpCjAwOjFjLjQgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDFIIChJ
Q0g4IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCA1IChyZXYgMDMpCjAwOjFkLjAgVVNCIENvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFVTQiBVSENJIENv
bnRyb2xsZXIgIzEgKHJldiAwMykKMDA6MWQuMSBVU0IgQ29udHJvbGxlcjogSW50ZWwgQ29ycG9y
YXRpb24gODI4MDFIIChJQ0g4IEZhbWlseSkgVVNCIFVIQ0kgQ29udHJvbGxlciAjMiAocmV2IDAz
KQowMDoxZC4yIFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUggKElDSDgg
RmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMzIChyZXYgMDMpCjAwOjFkLjcgVVNCIENvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSCAoSUNIOCBGYW1pbHkpIFVTQjIgRUhDSSBD
b250cm9sbGVyICMxIChyZXYgMDMpCjAwOjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRp
b24gODI4MDEgTW9iaWxlIFBDSSBCcmlkZ2UgKHJldiBmMykKMDA6MWYuMCBJU0EgYnJpZGdlOiBJ
bnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUhFTSAoSUNIOE0pIExQQyBJbnRlcmZhY2UgQ29udHJvbGxl
ciAocmV2IDAzKQowMDoxZi4xIElERSBpbnRlcmZhY2U6IEludGVsIENvcnBvcmF0aW9uIDgyODAx
SEJNL0hFTSAoSUNIOE0vSUNIOE0tRSkgSURFIENvbnRyb2xsZXIgKHJldiAwMykKMDA6MWYuMiBT
QVRBIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyODAxSEJNL0hFTSAoSUNIOE0vSUNI
OE0tRSkgU0FUQSBBSENJIENvbnRyb2xsZXIgKHJldiAwMykKMDI6MDAuMCBOZXR3b3JrIGNvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFBSTy9XaXJlbGVzcyAzOTQ1QUJHIFtHb2xhbl0gTmV0
d29yayBDb25uZWN0aW9uIChyZXYgMDIpCjAzOjAwLjAgRXRoZXJuZXQgY29udHJvbGxlcjogUmVh
bHRlayBTZW1pY29uZHVjdG9yIENvLiwgTHRkLiBSVEw4MTExLzgxNjhCIFBDSSBFeHByZXNzIEdp
Z2FiaXQgRXRoZXJuZXQgY29udHJvbGxlciAocmV2IDAxKQowNzowMy4wIEZpcmVXaXJlIChJRUVF
IDEzOTQpOiBSaWNvaCBDbyBMdGQgUjVDODMyIElFRUUgMTM5NCBDb250cm9sbGVyIChyZXYgMDUp
CjA3OjAzLjEgU0QgSG9zdCBjb250cm9sbGVyOiBSaWNvaCBDbyBMdGQgUjVDODIyIFNEL1NESU8v
TU1DL01TL01TUHJvIEhvc3QgQWRhcHRlciAocmV2IDIyKQowNzowMy4yIFN5c3RlbSBwZXJpcGhl
cmFsOiBSaWNvaCBDbyBMdGQgUjVDNTkyIE1lbW9yeSBTdGljayBCdXMgSG9zdCBBZGFwdGVyIChy
ZXYgMTIpCjA3OjAzLjMgU3lzdGVtIHBlcmlwaGVyYWw6IFJpY29oIENvIEx0ZCB4RC1QaWN0dXJl
IENhcmQgQ29udHJvbGxlciAocmV2IDEyKQo=
--001636417d1373ed010479fc3a22--

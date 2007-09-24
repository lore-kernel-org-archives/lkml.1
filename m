Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXIXWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXIXWDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbXIXWDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:03:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:51852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXIXWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=kTyXO+mtM4oCEBypBdER18hr/RJV+0PGI6sVOFlWbERc0bncCag+OpMscvjHwdm2GCdgh0A6NPUKbfDAidZmW2gTje6Oogb+4Oz5cTiQSmVX+W8tpS3i6thsRZaR+mC36sw+9WT4OZBojK4qABopTFiKiwN9FPztFrRxHq+PaX4=
Message-ID: <a56dfcf00709241503j58cc8f82lbb581f29b17ab3d5@mail.gmail.com>
Date: Mon, 24 Sep 2007 22:03:40 +0000
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [37/50] Fix inet_diag OOPS.
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "Patrick McHardy" <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070924162206.GL13510@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_36543_12718183.1190671420685"
References: <20070924161246.983665021@mini.kroah.org>
	 <20070924161733.GA13510@kroah.com> <20070924162206.GL13510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_36543_12718183.1190671420685
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 9/24/07, Greg KH <gregkh@suse.de> wrote:
> netlink_run_queue() doesn't handle multiple processes processing the
> queue concurrently. Serialize queue processing in inet_diag to fix
> a oops in netlink_rcv_skb caused by netlink_run_queue passing a
> NULL for the skb.

I just got this one on 2.6.23-RC1, looks the same to me but posting
the oops anyway to doublecheck.

(is it possible to get gmail not to mangle code/patches/oopses without
attaching?)

------=_Part_36543_12718183.1190671420685
Content-Type: text/plain; name="oops.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="oops.txt"
X-Attachment-Id: f_f6ziyvz5

WzEwMTUyMDUuMjQ1MjEzXSBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDA2OCBSSVA6IApbMTAxNTIwNS4yNDUyMjFdICBbPGZm
ZmZmZmZmODA0ZWI2YTU+XSBuZXRsaW5rX3J1bl9xdWV1ZSsweGIyLzB4MTA0ClsxMDE1MjA1LjI0
NTIzM10gUEdEIGE0NDkwNjcgUFVEIDJlODAzMDY3IFBNRCAwIApbMTAxNTIwNS4yNDUyMzddIE9v
cHM6IDAwMDAgWzFdIFNNUCAKWzEwMTUyMDUuMjQ1MjQwXSBDUFUgMSAKWzEwMTUyMDUuMjQ1MjQy
XSBNb2R1bGVzIGxpbmtlZCBpbjogdGNwX2RpYWcgaW5ldF9kaWFnIHJhZGVvbiBkcm0gaXNjc2lf
dGNwIGxpYmlzY3NpIHNjc2lfdHJhbnNwb3J0X2lzY3NpIGlwdjYgZnVzZSBlZXByb20gdHNkZXYg
dXNiaGlkIGZmX21lbWxlc3Mgc25kX2ludGVsOHgwIHNuZF9hYzk3X2NvZGVjIGZhbiBhYzk3X2J1
cyBzbmRfcGNtIHRoZXJtYWwgaTJjX25mb3JjZTIgazh0ZW1wIG9oY2kxMzk0IGVoY2lfaGNkIHNu
ZF90aW1lciBvaGNpX2hjZCBzZXJpb19yYXcgcGNzcGtyIHJ0YyBod21vbiBidXR0b24gcHJvY2Vz
c29yIHNuZCBzbmRfcGFnZV9hbGxvYyB1c2Jjb3JlIGkyY19jb3JlIGlkZV9nZW5lcmljClsxMDE1
MjA1LjI0NTI2N10gUGlkOiAyNjAzNiwgY29tbTogaWRlbnRkIE5vdCB0YWludGVkIDIuNi4yMy1y
YzMgIzEKWzEwMTUyMDUuMjQ1MjY5XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgwNGViNmE1Pl0gIFs8
ZmZmZmZmZmY4MDRlYjZhNT5dIG5ldGxpbmtfcnVuX3F1ZXVlKzB4YjIvMHgxMDQKWzEwMTUyMDUu
MjQ1Mjc0XSBSU1A6IDAwMTg6ZmZmZjgxMDAyYTFkNWJmOCAgRUZMQUdTOiAwMDAxMDIwMgpbMTAx
NTIwNS4yNDUyNzZdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4MTAwM2Q5NGY2MDAg
UkNYOiBmZmZmODEwMDBjOWZlM2MwClsxMDE1MjA1LjI0NTI3OF0gUkRYOiAwMDAwMDAwMDAwMDAw
MDA5IFJTSTogMDAwMDAwMDAwMDAwMDIwMiBSREk6IGZmZmY4MTAwM2Q5MWQwYzQKWzEwMTUyMDUu
MjQ1MjgxXSBSQlA6IDAwMDAwMDAwMDAwMDAwMDAgUjA4OiBmZmZmODEwMDA1OTgxM2MwIFIwOTog
ZmZmZjgxMDAzZDkxZDAwMApbMTAxNTIwNS4yNDUyODNdIFIxMDogMDAwMDAwMDA3ZmZmZmZmZiBS
MTE6IGZmZmY4MTAwMGM5ZmUzYzAgUjEyOiBmZmZmODEwMDJhMWQ1YzQ0ClsxMDE1MjA1LjI0NTI4
Nl0gUjEzOiBmZmZmODEwMDNkOTFkMDAwIFIxNDogZmZmZjgxMDAzZDkxZDBiMCBSMTU6IGZmZmZm
ZmZmODgxOWFhOTUKWzEwMTUyMDUuMjQ1Mjg5XSBGUzogIDAwMDAwMDAwNDEwMDE5NTAoMDA2Mykg
R1M6ZmZmZjgxMDAzZmFhYWE0MCgwMDAwKSBrbmxHUzowMDAwMDAwMGY3NDE1YTEwClsxMDE1MjA1
LjI0NTI5MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAz
YgpbMTAxNTIwNS4yNDUyOTRdIENSMjogMDAwMDAwMDAwMDAwMDA2OCBDUjM6IDAwMDAwMDAwMmM5
NzMwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmUwClsxMDE1MjA1LjI0NTI5Nl0gRFIwOiAwMDAwMDAw
MDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWzEw
MTUyMDUuMjQ1Mjk4XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYw
IERSNzogMDAwMDAwMDAwMDAwMDQwMApbMTAxNTIwNS4yNDUzMDFdIFByb2Nlc3MgaWRlbnRkIChw
aWQ6IDI2MDM2LCB0aHJlYWRpbmZvIGZmZmY4MTAwMmExZDQwMDAsIHRhc2sgZmZmZjgxMDAyYTNk
NTBjMCkKWzEwMTUyMDUuMjQ1MzAzXSBTdGFjazogIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjgxMDAz
ZDkxZDAwMCAwMDAwMDAwMDAwMDAwMDRjIGZmZmY4MTAwMWYyMTk0MDAKWzEwMTUyMDUuMjQ1MzA4
XSAgZmZmZjgxMDAzZDk0ZjYwMCBmZmZmODEwMDJhMWQ1ZDYwIDAwMDAwMDAwMDAwMDAwMDAgZmZm
ZmZmZmY4ODE5YTAyNApbMTAxNTIwNS4yNDUzMTFdICAwMDAwMDAwMDAwMDAwMjkyIDAwMDAwMDAx
ODA0Y2ZmZTQgZmZmZjgxMDAzZDkxZDAwMCBmZmZmZmZmZjgwNGViYjM3ClsxMDE1MjA1LjI0NTMx
NV0gQ2FsbCBUcmFjZToKWzEwMTUyMDUuMjQ1MzIzXSAgWzxmZmZmZmZmZjg4MTlhMDI0Pl0gOmlu
ZXRfZGlhZzppbmV0X2RpYWdfcmN2KzB4MjQvMHgyZgpbMTAxNTIwNS4yNDUzMjhdICBbPGZmZmZm
ZmZmODA0ZWJiMzc+XSBuZXRsaW5rX2RhdGFfcmVhZHkrMHgxMi8weDUwClsxMDE1MjA1LjI0NTMz
MV0gIFs8ZmZmZmZmZmY4MDRlYTkzZD5dIG5ldGxpbmtfc2VuZHNrYisweDIzLzB4M2QKWzEwMTUy
MDUuMjQ1MzM0XSAgWzxmZmZmZmZmZjgwNGViYjEyPl0gbmV0bGlua19zZW5kbXNnKzB4MmE5LzB4
MmJjClsxMDE1MjA1LjI0NTM0Ml0gIFs8ZmZmZmZmZmY4MDIyODQxYz5dIF9fd2FrZV91cF9jb21t
b24rMHgzZS8weDY4ClsxMDE1MjA1LjI0NTM0OF0gIFs8ZmZmZmZmZmY4MDRjYTY5Yz5dIHNvY2tf
YWlvX3dyaXRlKzB4MTEwLzB4MTI4ClsxMDE1MjA1LjI0NTM1N10gIFs8ZmZmZmZmZmY4MDI2NTRi
ZD5dIF9fcGFnZXZlY19scnVfYWRkX2FjdGl2ZSsweGQxLzB4ZTEKWzEwMTUyMDUuMjQ1MzYzXSAg
WzxmZmZmZmZmZjgwMjg0Mzg4Pl0gZG9fc3luY193cml0ZSsweGM5LzB4MTBjClsxMDE1MjA1LjI0
NTM3MV0gIFs8ZmZmZmZmZmY4MDI0MzU0Nj5dIGF1dG9yZW1vdmVfd2FrZV9mdW5jdGlvbisweDAv
MHgyZQpbMTAxNTIwNS4yNDUzODBdICBbPGZmZmZmZmZmODAyODRiNjA+XSB2ZnNfd3JpdGUrMHhl
MS8weDE1NwpbMTAxNTIwNS4yNDUzODVdICBbPGZmZmZmZmZmODAyODUwYWI+XSBzeXNfd3JpdGUr
MHg0NS8weDZlClsxMDE1MjA1LjI0NTM5MF0gIFs8ZmZmZmZmZmY4MDIwYjNjZT5dIHN5c3RlbV9j
YWxsKzB4N2UvMHg4MwpbMTAxNTIwNS4yNDUzOTZdIApbMTAxNTIwNS4yNDUzOTddIApbMTAxNTIw
NS4yNDUzOTddIENvZGU6IDhiIDU1IDY4IDgzIGZhIDBmIDc3IDkzIDQ4IDg5IGVmIGU4IGFkIDUw
IGZlIGZmIDQxIGZmIDBjIDI0IApbMTAxNTIwNS4yNDU0MDVdIFJJUCAgWzxmZmZmZmZmZjgwNGVi
NmE1Pl0gbmV0bGlua19ydW5fcXVldWUrMHhiMi8weDEwNApbMTAxNTIwNS4yNDU0MDldICBSU1Ag
PGZmZmY4MTAwMmExZDViZjg+ClsxMDE1MjA1LjI0NTQxMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDY4
Cg==
------=_Part_36543_12718183.1190671420685--

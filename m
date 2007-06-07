Return-Path: <linux-kernel-owner+w=401wt.eu-S937565AbXFGW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937565AbXFGW1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbXFGW1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:27:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:52462 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757387AbXFGW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:27:39 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX18Je29UzIAJS5V3HwgFqdEGPFcTrDlg6M9FgchSI+
	7AcyWkPsVcoNAr
Message-ID: <4668865A.5090300@gmx.de>
Date: Fri, 08 Jun 2007 00:27:38 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
Content-Type: multipart/mixed;
 boundary="------------000005010403010905090904"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------000005010403010905090904
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I asked vojtech@suse.cz as one of the driver developer

this is how I did it (just prototype, with implicite line =
discipline)

(neccessary just one folder and two files)
1. copy template linux-source/drivers/input/joystick/magellan.c
2. insert in line 90  :
     printk("%s:\"%s\"\n",__FUNCTION__, data);
3. make and insert it
4. inputattach --magellan /dev/ttyS0 &
5. date > /dev/ttyS0
6. dmesg | tail

voil=E0!

[output von dmesg]

     [27336.486980] serio: Serial port ttyS0
     [27336.487270] input: LogiCad3D Magellan / SpaceMouse as
/class/input/input6 [27336.518603] magellan_process_packet:"Mi =
 6 Jun
19:22:31 CEST 2007"

[/output]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGaIZbAAomYJ1taN8RAsMLAKDC1+OjCj+herKBXCNBknSu0K+uaACffNtk
Pdo0NVAjdBapHtg38m0u6Aw=3D
=3DDEP0
-----END PGP SIGNATURE-----

--------------000005010403010905090904
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lkwg82.vcf"

begin:vcard
fn:Lars K.W. Gohlke
n:Gohlke;Lars K.W.
email;internet:lkwg82@gmx.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000005010403010905090904--


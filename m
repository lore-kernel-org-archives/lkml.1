Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbYEXTuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbYEXTuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYEXTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:49:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57739 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYEXTtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=vgN4mKjBAJTX2l4duUUplidshQjbEiZpTSYobIRjwOJqvoOKU3ieGkS1ONN/vyWYM/V4C+VI67Lfjnz0g/L1MHoZKeu79lvT+2Dh0hTS2RLL3SiT3xTTdZP6gIUhCLTSmD12qHG5u4hVkk05sAqCu59ucjZQr1GnsJJ5+SeWP2U=
Message-ID: <48387154.8070204@gmail.com>
Date: Sat, 24 May 2008 14:49:40 -0500
From: Clark Williams <clark.williams@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: [PATCH -rt] fix for compiling 2.6.24.7-rt10 without CONFIG_FTRACE
References: <Pine.LNX.4.58.0805240221080.1841@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0805240221080.1841@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------080500000105040509040602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080500000105040509040602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Steven,

If you build a debugging kernel and don't have CONFIG_FTRACE turned on, -rt10 dies
when compiling arch/x86/kernel/x8664_ksyms_64.c, because ktime_t isn't defined in the
prototypes at the bottom of include/linux/ftrace.h. Patch to fix attached.

Clark


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkg4cVQACgkQqA4JVb61b9d0gQCffgzXgm2qaftlj5Q3fjjtyolD
J2MAnAoy4j9s2AUhZjwagT6OXzJ3Plgq
=9Ypr
-----END PGP SIGNATURE-----

--------------080500000105040509040602
Content-Type: text/plain;
 name="debug-compile-fix.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="debug-compile-fix.patch"

Zml4IHRvIGhhbmRsZSBjb21waWxpbmcgZGVidWdnaW5nIHdpdGhvdXQgQ09ORklHX0ZUUkFD
RQoKRnJvbTogQ2xhcmsgV2lsbGlhbXMgPHdpbGxpYW1zQHJlZGhhdC5jb20+CgpTaWduZWQt
b2ZmLWJ5OiBDbGFyayBXaWxsaWFtcyA8d2lsbGlhbXNAcmVkaGF0LmNvbT4KLS0tCgogaW5j
bHVkZS9saW51eC9mdHJhY2UuaCB8ICAgIDMgKystCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9mdHJhY2UuaCBiL2luY2x1ZGUvbGludXgvZnRyYWNlLmgKaW5kZXggNGMzOTBhZS4uNzYw
ZDRjZiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9mdHJhY2UuaAorKysgYi9pbmNsdWRl
L2xpbnV4L2Z0cmFjZS5oCkBAIC0xLDEwICsxLDExIEBACiAjaWZuZGVmIF9MSU5VWF9GVFJB
Q0VfSAogI2RlZmluZSBfTElOVVhfRlRSQUNFX0gKIAorI2luY2x1ZGUgPGxpbnV4L2t0aW1l
Lmg+CisKICNpZmRlZiBDT05GSUdfRlRSQUNFCiAKICNpbmNsdWRlIDxsaW51eC9saW5rYWdl
Lmg+Ci0jaW5jbHVkZSA8bGludXgva3RpbWUuaD4KICNpbmNsdWRlIDxsaW51eC9mcy5oPgog
CiBleHRlcm4gaW50IGZ0cmFjZV9lbmFibGVkOwo=
--------------080500000105040509040602--

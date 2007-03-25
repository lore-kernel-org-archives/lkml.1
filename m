Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXCYRHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXCYRHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXCYRHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:07:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:57977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXCYRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=KCIwQZgrnou9apGDtY8H4BujflXq4dVDg9Tvbo12Aqfaw6G1BO2CaNfZ8kcFYQLUfsx457DJeP4+Se6XV2rj5oC3UIvdXjFoXkqekJDRXb9jYH+ssCUbiCUOi/ME5sQKaFEcuUE91NB0NIvM4goXmED2RQzon4dWOuKyY8eqpMQ=
Message-ID: <82e4877d0703251007p390f4ed5g850dc5014fbeb66b@mail.gmail.com>
Date: Sun, 25 Mar 2007 13:07:41 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: apm.c: get rid of unused variables
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       "John Stultz" <johnstul@us.ibm.com>
In-Reply-To: <20070325162505.GN16477@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_135362_31960997.1174842461820"
References: <Pine.LNX.4.64.0703251158400.17623@paragw-desktop>
	 <20070325162505.GN16477@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_135362_31960997.1174842461820
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 3/25/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, Mar 25, 2007 at 12:06:19PM -0400, Parag Warudkar wrote:
> You could also remove the APM_RTC_IS_GMT config option.
>

Yep, that isn't used anymore. Separate Kconfig patch below and also attached.

Parag

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/arch/i386/Kconfig 2007-03-24 21:43:35.000000000 -0400
+++ linux-2.6-wk/arch/i386/Kconfig      2007-03-25 12:58:18.000000000 -0400
@@ -1029,19 +1029,6 @@
          backlight at all, or it might print a lot of errors to the console,
          especially if you are using gpm.

-config APM_RTC_IS_GMT
-       bool "RTC stores time in GMT"
-       depends on APM
-       help
-         Say Y here if your RTC (Real Time Clock a.k.a. hardware clock)
-         stores the time in GMT (Greenwich Mean Time). Say N if your RTC
-         stores localtime.
-
-         It is in fact recommended to store GMT in your RTC, because then you
-         don't have to worry about daylight savings time changes. The only
-         reason not to use GMT in your RTC is if you also run a broken OS
-         that doesn't understand GMT.
-
 config APM_ALLOW_INTS
        bool "Allow interrupts during APM BIOS calls"
        depends on APM

------=_Part_135362_31960997.1174842461820
Content-Type: text/x-patch; name=i386-kconfig-remove-apm_rtc_is_gmt.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ezpqua97
Content-Disposition: attachment; filename="i386-kconfig-remove-apm_rtc_is_gmt.patch"

LS0tIGxpbnV4LTIuNi9hcmNoL2kzODYvS2NvbmZpZwkyMDA3LTAzLTI0IDIxOjQzOjM1LjAwMDAw
MDAwMCAtMDQwMAorKysgbGludXgtMi42LXdrL2FyY2gvaTM4Ni9LY29uZmlnCTIwMDctMDMtMjUg
MTI6NTg6MTguMDAwMDAwMDAwIC0wNDAwCkBAIC0xMDI5LDE5ICsxMDI5LDYgQEAKIAkgIGJhY2ts
aWdodCBhdCBhbGwsIG9yIGl0IG1pZ2h0IHByaW50IGEgbG90IG9mIGVycm9ycyB0byB0aGUgY29u
c29sZSwKIAkgIGVzcGVjaWFsbHkgaWYgeW91IGFyZSB1c2luZyBncG0uCiAKLWNvbmZpZyBBUE1f
UlRDX0lTX0dNVAotCWJvb2wgIlJUQyBzdG9yZXMgdGltZSBpbiBHTVQiCi0JZGVwZW5kcyBvbiBB
UE0KLQloZWxwCi0JICBTYXkgWSBoZXJlIGlmIHlvdXIgUlRDIChSZWFsIFRpbWUgQ2xvY2sgYS5r
LmEuIGhhcmR3YXJlIGNsb2NrKQotCSAgc3RvcmVzIHRoZSB0aW1lIGluIEdNVCAoR3JlZW53aWNo
IE1lYW4gVGltZSkuIFNheSBOIGlmIHlvdXIgUlRDCi0JICBzdG9yZXMgbG9jYWx0aW1lLgotCi0J
ICBJdCBpcyBpbiBmYWN0IHJlY29tbWVuZGVkIHRvIHN0b3JlIEdNVCBpbiB5b3VyIFJUQywgYmVj
YXVzZSB0aGVuIHlvdQotCSAgZG9uJ3QgaGF2ZSB0byB3b3JyeSBhYm91dCBkYXlsaWdodCBzYXZp
bmdzIHRpbWUgY2hhbmdlcy4gVGhlIG9ubHkKLQkgIHJlYXNvbiBub3QgdG8gdXNlIEdNVCBpbiB5
b3VyIFJUQyBpcyBpZiB5b3UgYWxzbyBydW4gYSBicm9rZW4gT1MKLQkgIHRoYXQgZG9lc24ndCB1
bmRlcnN0YW5kIEdNVC4KLQogY29uZmlnIEFQTV9BTExPV19JTlRTCiAJYm9vbCAiQWxsb3cgaW50
ZXJydXB0cyBkdXJpbmcgQVBNIEJJT1MgY2FsbHMiCiAJZGVwZW5kcyBvbiBBUE0K
------=_Part_135362_31960997.1174842461820--

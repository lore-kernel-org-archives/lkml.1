Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXEHJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXEHJTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934617AbXEHJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:19:18 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:28499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934570AbXEHJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:mime-version:content-type;
        b=mI85Xts7tRUEUjBr52cTcMjNZ2oIHqKuQvyRQ7dmv/Zk5HjvxHukTBUSqH5pSWR97WRgfeoXQZOpZWhjRBc2/6hON+MdEPWoiQRwwWekjLH/Jeazas0UGsyyFqD+zUmk6Z2gMO3xL7eZau0pwlf+VR/V5lB7oCVj2uA2Rjg60FU=
Message-ID: <3efb10970705080219j21f8d5f2n26250548bcdebf30@mail.gmail.com>
Date: Tue, 8 May 2007 11:19:16 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: andrew@sanpeople.com
Subject: [PATCH]: Make LEDS work on evaluation board AT91SAM9261-EK
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_23640_18872116.1178615956220"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_23640_18872116.1178615956220
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Andrew,

Attached you can find a patch needed to make the LEDS for 'CPU-Idle'
and 'Timer' work on the AT91SAM9261-EK board. The kernel configuration
options are already there, but the implementation is not available.
This patch fixes this.

Can you please apply this patch to the kernel mainline?

Kind Regards,

Remy Bohmer

------=_Part_23640_18872116.1178615956220
Content-Type: text/x-patch; name=leds.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1g4tshb
Content-Disposition: attachment; filename="leds.diff"

ZGlmZiAtcnVOIGxpbnV4LTIuNi4yMS5vcmlnL2FyY2gvYXJtL21hY2gtYXQ5MS9ib2FyZC1zYW05
MjYxZWsuYyBsaW51eC0yLjYuMjEvYXJjaC9hcm0vbWFjaC1hdDkxL2JvYXJkLXNhbTkyNjFlay5j
Ci0tLSBsaW51eC0yLjYuMjEub3JpZy9hcmNoL2FybS9tYWNoLWF0OTEvYm9hcmQtc2FtOTI2MWVr
LmMJMjAwNy0wNS0wNCAxNTo1MTozNC4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yMS9h
cmNoL2FybS9tYWNoLWF0OTEvYm9hcmQtc2FtOTI2MWVrLmMJMjAwNy0wNS0wNyAxNjo0NTowNC4w
MDAwMDAwMDAgKzAyMDAKQEAgLTU5LDYgKzU5LDkgQEAKIAkvKiBJbml0aWFsaXplIHByb2Nlc3Nv
cjogMTguNDMyIE1IeiBjcnlzdGFsICovCiAJYXQ5MXNhbTkyNjFfaW5pdGlhbGl6ZSgxODQzMjAw
MCk7CiAKKwkvKiBTZXR1cCB0aGUgTEVEcyAqLworCWF0OTFfaW5pdF9sZWRzKEFUOTFfUElOX1BB
MTMsIEFUOTFfUElOX1BBMTQpOworCiAJLyogU2V0dXAgdGhlIHNlcmlhbCBwb3J0cyBhbmQgY29u
c29sZSAqLwogCWF0OTFfaW5pdF9zZXJpYWwoJmVrX3VhcnRfY29uZmlnKTsKIH0KZGlmZiAtcnVO
IGxpbnV4LTIuNi4yMS5vcmlnL2FyY2gvYXJtL21hY2gtYXQ5MS9NYWtlZmlsZSBsaW51eC0yLjYu
MjEvYXJjaC9hcm0vbWFjaC1hdDkxL01ha2VmaWxlCi0tLSBsaW51eC0yLjYuMjEub3JpZy9hcmNo
L2FybS9tYWNoLWF0OTEvTWFrZWZpbGUJMjAwNy0wNS0wNCAxNTo1MTozNC4wMDAwMDAwMDAgKzAy
MDAKKysrIGxpbnV4LTIuNi4yMS9hcmNoL2FybS9tYWNoLWF0OTEvTWFrZWZpbGUJMjAwNy0wNS0w
NyAxNzozNDoyMS4wMDAwMDAwMDAgKzAyMDAKQEAgLTM4LDYgKzM5LDcgQEAKICMgTEVEcyBzdXBw
b3J0CiBsZWQtJChDT05GSUdfQVJDSF9BVDkxUk05MjAwREspCSs9IGxlZHMubwogbGVkLSQoQ09O
RklHX01BQ0hfQVQ5MVJNOTIwMEVLKQkrPSBsZWRzLm8KK2xlZC0kKENPTkZJR19NQUNIX0FUOTFT
QU05MjYxRUspKz0gbGVkcy5vCiBsZWQtJChDT05GSUdfTUFDSF9DU0IzMzcpCSs9IGxlZHMubwog
bGVkLSQoQ09ORklHX01BQ0hfQ1NCNjM3KQkrPSBsZWRzLm8KIGxlZC0kKENPTkZJR19NQUNIX0tC
OTIwMCkJKz0gbGVkcy5vCg==
------=_Part_23640_18872116.1178615956220--

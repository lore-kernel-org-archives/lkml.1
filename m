Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZBYJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZBYJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbZBYJEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:04:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:23127 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbZBYJEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qowid2r/9Nltk7aCiURl+QM7EZDUAokiIyhFpLOopXZunuLTaNm6yV5gwQWnztEtKG
         eS0E8MbNopFhztgbg/3ueN4HdglpEV3a5t4bqu3dt9uMRDxdBqWpj9j2TS3scLPPC+qK
         kxT/Nrw1vd7kgMOfS0z9Ggv6EBz4csMjUhBJg=
MIME-Version: 1.0
Date: Wed, 25 Feb 2009 10:04:37 +0100
Message-ID: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com>
Subject: [PATCH] Use a format string for linux_banner
From: Alex Riesen <raa.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Content-Type: multipart/mixed; boundary=0015174bdf286cdff10463ba864b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174bdf286cdff10463ba864b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There is no format specifiers left in the linux_banner,
and gcc complains seeing the printk.

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--0015174bdf286cdff10463ba864b
Content-Type: application/octet-stream; 
	name="0001-Use-a-format-for-linux_banner.diff"
Content-Disposition: attachment; 
	filename="0001-Use-a-format-for-linux_banner.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frls5aej0

RnJvbSBlN2I0NGM0YzFkN2QwZjE4MmYwMTAwYjBkYzMxYzIwZmIzZGZlOGVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IFJpZXNlbiA8cmFhLmxrbWxAZ21haWwuY29tPgpEYXRl
OiBXZWQsIDI1IEZlYiAyMDA5IDA5OjUzOjE1ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gVXNlIGEg
Zm9ybWF0IHN0cmluZyBmb3IgbGludXhfYmFubmVyCgpUaGVyZSBpcyBubyBmb3JtYXQgc3BlY2lm
aWVycyBsZWZ0IGluIHRoZSBsaW51eF9iYW5uZXIsCmFuZCBnY2MgY29tcGxhaW5zIHNlZWluZyB0
aGUgcHJpbnRrLgoKU2lnbmVkLW9mZi1ieTogQWxleCBSaWVzZW4gPHJhYS5sa21sQGdtYWlsLmNv
bT4KLS0tCiBpbml0L21haW4uYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luaXQvbWFpbi5jIGIvaW5pdC9t
YWluLmMKaW5kZXggODQ0MjA5NC4uNzhmYzBkOCAxMDA2NDQKLS0tIGEvaW5pdC9tYWluLmMKKysr
IGIvaW5pdC9tYWluLmMKQEAgLTU1NCw3ICs1NTQsNyBAQCBhc21saW5rYWdlIHZvaWQgX19pbml0
IHN0YXJ0X2tlcm5lbCh2b2lkKQogCWJvb3RfY3B1X2luaXQoKTsKIAlwYWdlX2FkZHJlc3NfaW5p
dCgpOwogCXByaW50ayhLRVJOX05PVElDRSk7Ci0JcHJpbnRrKGxpbnV4X2Jhbm5lcik7CisJcHJp
bnRrKCIlcyIsIGxpbnV4X2Jhbm5lcik7CiAJc2V0dXBfYXJjaCgmY29tbWFuZF9saW5lKTsKIAlt
bV9pbml0X293bmVyKCZpbml0X21tLCAmaW5pdF90YXNrKTsKIAlzZXR1cF9jb21tYW5kX2xpbmUo
Y29tbWFuZF9saW5lKTsKLS0gCjEuNi4yLnJjMS40Ni5nYjNlYzg0ZgoK
--0015174bdf286cdff10463ba864b--

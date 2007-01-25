Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXAYRsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXAYRsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965354AbXAYRsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:48:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:19183 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXAYRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=SYvGujl2naC0/pNh7o+1Za7cGI9FlrkXuWE+6zjGaWyIfSPgFtiKPrH5aFAC1eCRpa2Fn4fH/ih0alpApaDA0zxfI9QSZ97IooYybW+yo+R9rjbZ4iVYjAyQbWfD9oQL9beF/Po0az9JLK5VlTJPZaQDSoGb8+0v8G7V4VC+kxE=
Message-ID: <806dafc20701250948s2f586bb9g4b217cbfe226a51@mail.gmail.com>
Date: Thu, 25 Jan 2007 12:48:12 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38731_12296310.1169747292064"
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38731_12296310.1169747292064
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Updated version of patch also taking into account feedback from
Takashi is attached.

I'm going to look at hald now.

Monty

------=_Part_38731_12296310.1169747292064
Content-Type: text/plain; name="alsa-sysfs-fix-2.6.20-rc5-updated.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="alsa-sysfs-fix-2.6.20-rc5-updated.txt"
X-Attachment-Id: f_exdhbt3w

ZGlmZiAtdXByTiAtWCBsaW51eC0yLjYuMjAtcmM1L0RvY3VtZW50YXRpb24vZG9udGRpZmYgbGlu
dXgtMi42LjIwLXJjNS9zb3VuZC9jb3JlL3NvdW5kLmMgbGludXgtMi42LjIwLXJjNS1tb250eS9z
b3VuZC9jb3JlL3NvdW5kLmMKLS0tIGxpbnV4LTIuNi4yMC1yYzUvc291bmQvY29yZS9zb3VuZC5j
CTIwMDctMDEtMTIgMTM6NTQ6MjYuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjAtcmM1
LW1vbnR5L3NvdW5kL2NvcmUvc291bmQuYwkyMDA3LTAxLTI1IDEyOjMxOjI4LjAwMDAwMDAwMCAt
MDUwMApAQCAtMjY0LDggKzI2NCwxMCBAQCBpbnQgc25kX3JlZ2lzdGVyX2RldmljZShpbnQgdHlw
ZSwgc3RydWN0CiAJfQogCXNuZF9taW5vcnNbbWlub3JdID0gcHJlZzsKIAlpZiAoY2FyZCkKLQkJ
ZGV2aWNlID0gY2FyZC0+ZGV2OwotCXByZWctPmRldiA9IGRldmljZV9jcmVhdGUoc291bmRfY2xh
c3MsIGRldmljZSwgTUtERVYobWFqb3IsIG1pbm9yKSwKKwkJZGV2aWNlID0gY2FyZC0+cGFyZW50
OworCXByZWctPmRldiA9IGRldmljZV9jcmVhdGUoc291bmRfY2xhc3MsCisJCQkJICBkZXZpY2Us
CisJCQkJICBNS0RFVihtYWpvciwgbWlub3IpLAogCQkJCSAgIiVzIiwgbmFtZSk7CiAJaWYgKHBy
ZWctPmRldikKIAkJZGV2X3NldF9kcnZkYXRhKHByZWctPmRldiwgcHJpdmF0ZV9kYXRhKTsKZGlm
ZiAtdXByTiAtWCBsaW51eC0yLjYuMjAtcmM1L0RvY3VtZW50YXRpb24vZG9udGRpZmYgbGludXgt
Mi42LjIwLXJjNS9zb3VuZC9zb3VuZF9jb3JlLmMgbGludXgtMi42LjIwLXJjNS1tb250eS9zb3Vu
ZC9zb3VuZF9jb3JlLmMKLS0tIGxpbnV4LTIuNi4yMC1yYzUvc291bmQvc291bmRfY29yZS5jCTIw
MDctMDEtMTIgMTM6NTQ6MjYuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjAtcmM1LW1v
bnR5L3NvdW5kL3NvdW5kX2NvcmUuYwkyMDA3LTAxLTI1IDEyOjA0OjMwLjAwMDAwMDAwMCAtMDUw
MApAQCAtMTcwLDcgKzE3MCw4IEBAIHN0YXRpYyBpbnQgc291bmRfaW5zZXJ0X3VuaXQoc3RydWN0
IHNvdW4KIAllbHNlCiAJCXNwcmludGYocy0+bmFtZSwgInNvdW5kLyVzJWQiLCBuYW1lLCByIC8g
U09VTkRfU1RFUCk7CiAKLQlkZXZpY2VfY3JlYXRlKHNvdW5kX2NsYXNzLCBkZXYsIE1LREVWKFNP
VU5EX01BSk9SLCBzLT51bml0X21pbm9yKSwKKwlkZXZpY2VfY3JlYXRlKHNvdW5kX2NsYXNzLCAo
ZGV2P2Rldi0+cGFyZW50Ok5VTEwpLCAKKwkJICAgICAgTUtERVYoU09VTkRfTUFKT1IsIHMtPnVu
aXRfbWlub3IpLAogCQkgICAgICBzLT5uYW1lKzYpOwogCXJldHVybiByOwogCg==
------=_Part_38731_12296310.1169747292064--

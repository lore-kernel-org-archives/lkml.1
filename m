Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZDKSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZDKSOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbZDKSNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:13:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:41477 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbZDKSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OKZ5TynrJed7AtGAqTq3oFZcbEFMGLiKtUOhEiJdh05DoB2pDvC+B7VJs03eUne/SY
         OOYyGfNUyGjFTNQUthbiYJJaVL5vaRqanPBtgJLnEQ58saem4T2Zx+/+BYohxbWlq1cv
         wkwJwFwLBXe1yLe/z0CZStNR5KVI6sJ0pwIqc=
MIME-Version: 1.0
In-Reply-To: <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
	 <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
Date: Sat, 11 Apr 2009 23:43:48 +0530
Message-ID: <81083a450904111113k4f2dd50et18585bf3c2dce8f2@mail.gmail.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute 
	structure in sysfs
From: Ashutosh Naik <ashutosh.naik@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pjones@redhat.com,
       konradr@linux.vnet.ibm.com, ketuzsezr@darnok.org,
       "Vishnu V. Mandyam" <vishnu@chelsio.com>, open-iscsi@googlegroups.com
Content-Type: multipart/mixed; boundary=0016e643594850546404674b7167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e643594850546404674b7167
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2009 at 11:26 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> What do these signoffs mean?

I am reattaching the patch here:

Description:This patch fixes the display of a few fields in the iBFT
NIC attribute
structure in sysfs.

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Vishnu V<vishnu@chelsio.com>

> The second question is who picks this up? =A0The drivers/firmware
> directory doesn't seem to have a dedicated tree, so I can take this
> through the SCSI tree if required or Andrew can take it through -mm.

This is used for display of the various structures of the iBFT table
via sysfs and can be picked up by any iSCSI initiator driver module
that uses the information in the iBFT table to boot over iSCSI, such
as open-iscsi.

--0016e643594850546404674b7167
Content-Type: text/plain; charset=US-ASCII; 
	name="iscsi_ibft_c_fix_nic_attribute_display_in_sysfs.txt"
Content-Disposition: attachment; 
	filename="iscsi_ibft_c_fix_nic_attribute_display_in_sysfs.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftemesao0

ZGlmZiAtcnVOIGxpbnV4LTIuNi4yOS4xLW9yaWcvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0
LmMgbGludXgtMi42LjI5LjEvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0LmMKLS0tIGxpbnV4
LTIuNi4yOS4xLW9yaWcvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0LmMJMjAwOS0wNC0xMSAx
ODoyNTo0MC4wMDAwMDAwMDAgKzA1MzAKKysrIGxpbnV4LTIuNi4yOS4xL2RyaXZlcnMvZmlybXdh
cmUvaXNjc2lfaWJmdC5jCTIwMDktMDQtMTEgMTg6MzM6NDIuMDAwMDAwMDAwICswNTMwCkBAIC03
NTQsMTEgKzc1NCwxMSBAQAogCQlyYyA9IDE7CiAJCWJyZWFrOwogCWNhc2UgaWJmdF9ldGhfaXBf
YWRkcjoKLQkJaWYgKCFtZW1jbXAobmljLT5kaGNwLCBudWxscywgc2l6ZW9mKG5pYy0+ZGhjcCkp
KQorCQlpZiAobWVtY21wKG5pYy0+aXBfYWRkciwgbnVsbHMsIHNpemVvZihuaWMtPmlwX2FkZHIp
KSkKIAkJCXJjID0gMTsKIAkJYnJlYWs7CiAJY2FzZSBpYmZ0X2V0aF9zdWJuZXRfbWFzazoKLQkJ
aWYgKCFtZW1jbXAobmljLT5kaGNwLCBudWxscywgc2l6ZW9mKG5pYy0+ZGhjcCkpKQorCQlpZiAo
bmljLT5zdWJuZXRfbWFza19wcmVmaXgpCiAJCQlyYyA9IDE7CiAJCWJyZWFrOwogCWNhc2UgaWJm
dF9ldGhfb3JpZ2luOgo=
--0016e643594850546404674b7167--

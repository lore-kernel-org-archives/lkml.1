Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZFWFMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZFWFMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZFWFLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:11:50 -0400
Received: from mail-yx0-f196.google.com ([209.85.210.196]:44708 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFWFLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RpJd97FWbAUGgv6sOerobJZSpudsNlRkr51ZlHfrJPv5z0C5dadUqxTtLvCynoaE4m
         1CWwl2woAmwleXcl18iwVWR5Pzzs7CrLZLRe3KZ9fMCt2U+8byS2bf0KGNQpjTe/spGL
         hYKsuExagfXWkg74GYoNsstfqkWALJBhxQgrs=
MIME-Version: 1.0
Date: Tue, 23 Jun 2009 13:11:51 +0800
Message-ID: <b6a2187b0906222211i4509bc4cu39e9123cba61039a@mail.gmail.com>
Subject: can we move USB_DEVICEFS to non-embedded?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: multipart/mixed; boundary=001636163d194e7069046cfd072e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636163d194e7069046cfd072e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

commit cc71329b3b89b4a5be849b617f2c4f151f0b9213 moved USB_DEVICEFS to
be embedded and marked it as depreciated. Can this be reverted? This
breaks vmware and those systems not using udev.

Here's a small patch to move it as non-embedded.

Thanks,
Jeff.

--001636163d194e7069046cfd072e
Content-Type: application/octet-stream; name=patch-usbfs
Content-Disposition: attachment; filename=patch-usbfs
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwa5sj2m0

LS0tIGEvZHJpdmVycy91c2IvY29yZS9LY29uZmlnLm9yZwkyMDA5LTA2LTIzIDEyOjIyOjUxICsw
ODAwCisrKyBhL2RyaXZlcnMvdXNiL2NvcmUvS2NvbmZpZwkyMDA5LTA2LTIzIDEyOjIzOjAwICsw
ODAwCkBAIC0yOCw3ICsyOCw3IEBACiAJZGVwZW5kcyBvbiBVU0IKIAogY29uZmlnIFVTQl9ERVZJ
Q0VGUwotCWJvb2wgIlVTQiBkZXZpY2UgZmlsZXN5c3RlbSAoREVQUkVDQVRFRCkiIGlmIEVNQkVE
REVECisJYm9vbCAiVVNCIGRldmljZSBmaWxlc3lzdGVtIChERVBSRUNBVEVEKSIKIAlkZXBlbmRz
IG9uIFVTQgogCS0tLWhlbHAtLS0KIAkgIElmIHlvdSBzYXkgWSBoZXJlIChhbmQgdG8gIi9wcm9j
IGZpbGUgc3lzdGVtIHN1cHBvcnQiIGluIHRoZSAiRmlsZQo=
--001636163d194e7069046cfd072e--

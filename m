Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZIWU7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZIWU7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZIWU7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:59:46 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:56859 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZIWU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=q0wKR4MkQBZeQahXF/3LaOWJO9zlLsFlzhPAmUh/V/1LjpOKFsIWd2wTE5U+VPhOfp
         41qgFv2F0oE15igVq5RSvHdRDFFMjGQBXrGLggYu6NNQo3qJE+jVet0/5ZlCPbaTghFA
         NMFO11o2hl8w132xKa298DNqo/3al4ED+T8Qg=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 21:59:47 +0100
Message-ID: <5a44caba0909231359q5835a293h24882e7f22b0db95@mail.gmail.com>
Subject: PATCH 1/1: rt2x00dev.c / rt2x00lib.h fixes build breakage
From: Ken Lewis <kennylewis@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016364d1da1c05d37047444fe54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d1da1c05d37047444fe54
Content-Type: text/plain; charset=ISO-8859-1

The headers in drivers/net/wireless/rt2x00/rt2x00lib.h don't match the
use of the function in rt2x00dev.c  The build fails as a result.

This has been a problem in linux-next since early September.  I've
e-mailed a patch to linux-next and to linux-net, but the 2.6.32 merge
window has brought the problem to the mainline and so I'm re-sending
my patch.  I've opened a bug on bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=14217

Take care.
Ken

--0016364d1da1c05d37047444fe54
Content-Type: text/x-diff; charset=US-ASCII; name="diff-fix-for-rt2x00lib.h.patch"
Content-Disposition: attachment; filename="diff-fix-for-rt2x00lib.h.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzyk4zkw0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDJ4MDBsaWIuaCBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDJ4MDBsaWIuaAppbmRleCA1NDYyY2I1Li41Njdm
MDI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyeDAwbGliLmgK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMGxpYi5oCkBAIC0zODAsNyAr
MzgwLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHJ0MngwMGNyeXB0b190eF9pbnNlcnRfaXYoc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwKIHsKIH0KIAotc3RhdGljIGlubGluZSB2b2lkIHJ0MngwMGNyeXB0
b19yeF9pbnNlcnRfaXYoc3RydWN0IHNrX2J1ZmYgKnNrYiwgYm9vbCBsMnBhZCwKK3N0YXRpYyBp
bmxpbmUgdm9pZCBydDJ4MDBjcnlwdG9fcnhfaW5zZXJ0X2l2KHN0cnVjdCBza19idWZmICpza2Is
CiAJCQkJCSAgICAgdW5zaWduZWQgaW50IGhlYWRlcl9sZW5ndGgsCiAJCQkJCSAgICAgc3RydWN0
IHJ4ZG9uZV9lbnRyeV9kZXNjICpyeGRlc2MpCiB7Cg==
--0016364d1da1c05d37047444fe54--

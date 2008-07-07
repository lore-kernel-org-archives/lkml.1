Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYGGSQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYGGSQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYGGSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:16:34 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15597 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbYGGSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=DBldlE1t0SEQ7bxHHcUn7Pmy4qCLY7u7ga+AvCdI5dXCk/FCLsQRT5wuoGDlqStVq1
         FV0WLF8r0g6HLHqb0gUiJlbBn53/BWZW4tPzpO/f+76lsd7H8ChAq7w33DnkbObu5Q6Q
         bb5urMBqDE8tMd42ubejSoaghgiAsWuQPJmrQ=
Message-ID: <48725D71.6040202@gmail.com>
Date: Mon, 07 Jul 2008 14:16:17 -0400
From: Jerry Hicks <hickswgjr@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/chips/jedec_probe.c (linux-2.6.25.10)
Content-Type: multipart/mixed;
 boundary="------------000604000100080701020500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000604000100080701020500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The device id for Am29DL800BB in jedec_probe.c is wrong.

Reference:  http://www.spansion.com/datasheets/21519c4.pdf

I discovered this while working with u-boot.

The u-boot folks mentioned Linux as an upstream reference, thought I'd 
post a heads-up here too.

Cheers,

Jerry Hicks

--------------000604000100080701020500
Content-Type: application/octet-stream;
 name="jedec_probe.c.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="jedec_probe.c.patch"

LS0tIGxpbnV4LTIuNi4yNS4xMC9kcml2ZXJzL210ZC9jaGlwcy9qZWRlY19wcm9iZS5jLm9y
aWcJMjAwOC0wNy0wMiAyMzo0Njo0Ny4wMDAwMDAwMDAgLTA0MDAKKysrIGxpbnV4LTIuNi4y
NS4xMC9kcml2ZXJzL210ZC9jaGlwcy9qZWRlY19wcm9iZS5jCTIwMDgtMDctMDcgMTI6NDk6
MzQuMTkxNDAwMDAwIC0wNDAwCkBAIC00MCw3ICs0MCw3IEBACiAKIAogLyogQU1EICovCi0j
ZGVmaW5lIEFNMjlETDgwMEJCCTB4MjJDOAorI2RlZmluZSBBTTI5REw4MDBCQgkweDIyQ0IK
ICNkZWZpbmUgQU0yOURMODAwQlQJMHgyMjRBCiAKICNkZWZpbmUgQU0yOUY4MDBCQgkweDIy
NTgK
--------------000604000100080701020500--

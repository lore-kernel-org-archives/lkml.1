Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYIZKdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYIZKdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYIZKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:33:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:56116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYIZKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=M6UqE4sGLdPynwvm9HarVUq2l56nktPNEkT4zYAV/7TFNsjTYwtnPIhFyhV3hlaL5N
         1XxpY6MJTfcGxHgUdxHGLN5IyTTvtFDdeEC+qzBuul864v28eL2y4DMWwNS82tFyq9DF
         tcbu8p0x6acuqITEVJYFo6TODYeh0vcyr+lkA=
Message-ID: <cfd18e0f0809260333l40bb2e32p2a0b5626b2823d25@mail.gmail.com>
Date: Fri, 26 Sep 2008 12:33:13 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Documentation/HOWTO: info about interface changes should CC linux-api@vger
Cc: lkml <linux-kernel@vger.kernel.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Greg KH" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "Documentation" section of this file mentions that when an
interface change is made, I should be CCed with info about the change
(so that man-pages can document it).  Additionally request that this
info be CCed to the new linux-api@vger.kernel.org list.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index c2371c5..48a3955 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -77,7 +77,8 @@ documentation files are also added which explain how
to use the feature.
 When a kernel change causes the interface that the kernel exposes to
 userspace to change, it is recommended that you send the information or
 a patch to the manual pages explaining the change to the manual pages
-maintainer at mtk.manpages@gmail.com.
+maintainer at mtk.manpages@gmail.com, and CC the list
+linux-api@vger.kernel.org.

 Here is a list of files that are in the kernel source tree that are
 required reading:

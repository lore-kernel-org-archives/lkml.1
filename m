Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYIZKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYIZKVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYIZKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:21:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:56436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYIZKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=rZYExUMo/a2ANK2chzcuyJOjptws2mpAfBSq0V3lhFQh+AYvt0aTGoT0SScMJIlSKS
         0lyFKTMYQHl5EG93NLR6is5E5dHJgoEd6xxyGjDojQeDWn66vzHxw3Js58y8J0Gnu3tS
         ndmMKdabbLCkhXdz5zgcVPqafeYLyPv5Igdcs=
Message-ID: <cfd18e0f0809260321xbf0a304nd80fbd76b6dcc667@mail.gmail.com>
Date: Fri, 26 Sep 2008 12:21:43 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] SubmitChecklist: interfaces changes should CC linux-api@
Cc: lkml <linux-kernel@vger.kernel.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Greg KH" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention that patches that change the kernel-userland interface should
be CCed to the new list linux-api@vger.kernel.org.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index da10e07..21f0795 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -67,6 +67,8 @@ kernel patches.

 19: All new userspace interfaces are documented in Documentation/ABI/.
     See Documentation/ABI/README for more information.
+    Patches that change userspace interfaces should be CCed to
+    linux-api@vger.kernel.org.

 20: Check that it all passes `make headers_check'.

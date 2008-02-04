Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYBDXnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYBDXnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYBDXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:43:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51232 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755143AbYBDXnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:43:24 -0500
Date: Tue, 5 Feb 2008 00:43:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: CodingStyle: provide good example
Message-ID: <20080204234343.GA1901@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if (!buffer) is actually prefered style, so lets use it in example.

								Pavel

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6caa146..9bb2d8a 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -406,7 +415,7 @@ int fun(int a)
 	int result = 0;
 	char *buffer = kmalloc(SIZE);
 
-	if (buffer == NULL)
+	if (!buffer)
 		return -ENOMEM;
 
 	if (condition1) {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYCYA1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYCYA1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYCYA1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:27:15 -0400
Received: from testure.choralone.org ([194.9.77.134]:57716 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYCYA1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:27:14 -0400
Date: Mon, 24 Mar 2008 20:27:05 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Silence two kerneldoc warnings in kernel/audit.c
Message-ID: <20080325002705.GA25116@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence two kerneldoc warnings.

Warning(kernel/audit.c:1276): No description found for parameter 'string'
Warning(kernel/audit.c:1276): No description found for parameter 'len'

[also fix a typo for bonus points]

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

--- linux-2.6.24.noarch/kernel/audit.c~	2008-03-24 20:22:32.000000000 -0400
+++ linux-2.6.24.noarch/kernel/audit.c	2008-03-24 20:23:34.000000000 -0400
@@ -1269,8 +1269,8 @@ static void audit_log_n_string(struct au
 
 /**
  * audit_string_contains_control - does a string need to be logged in hex
- * @string - string to be checked
- * @len - max length of the string to check
+ * @string: string to be checked
+ * @len: max length of the string to check
  */
 int audit_string_contains_control(const char *string, size_t len)
 {
@@ -1285,7 +1285,7 @@ int audit_string_contains_control(const 
 /**
  * audit_log_n_untrustedstring - log a string that may contain random characters
  * @ab: audit_buffer
- * @len: lenth of string (not including trailing null)
+ * @len: length of string (not including trailing null)
  * @string: string to be logged
  *
  * This code will escape a string that is passed to it if the string


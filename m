Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXDJLZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXDJLZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDJLZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:25:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58824 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXDJLZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:25:16 -0400
X-Originating-Ip: 74.109.98.130
Date: Tue, 10 Apr 2007 07:23:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Add spaces on either side of case "..." operator.
Message-ID: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Following the programming advice laid down in the gcc manual, make
sure the case "..." operator has spaces on either side.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

According to:

http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Case-Ranges.html#Case-Ranges:

  "Be careful: Write spaces around the ..., for otherwise it may be
parsed wrong when you use it with integer values."


diff --git a/kernel/audit.c b/kernel/audit.c
index 76c9a11..d963a04 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -515,8 +515,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 			err = -EPERM;
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (security_netlink_recv(skb, CAP_AUDIT_WRITE))
 			err = -EPERM;
 		break;
@@ -614,8 +614,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 							loginuid, sid);
 		break;
 	case AUDIT_USER:
-	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
-	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
+	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
+	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

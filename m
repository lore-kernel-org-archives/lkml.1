Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYFMLMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYFMLMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYFMLMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:12:30 -0400
Received: from server78.greatnet.de ([83.133.96.102]:44024 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYFMLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:12:30 -0400
X-Greylist: delayed 1442 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 07:12:29 EDT
Message-ID: <48525074.9020907@nachtwindheim.de>
Date: Fri, 13 Jun 2008 12:48:20 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] audit:  kerneldoc fix for sessionid
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sessionid kerneldoc to auditfilter.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 0e0bd27..e49c2d7 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1544,6 +1544,7 @@ static void audit_log_rule_change(uid_t loginuid, u32 sessionid, u32 sid,
  * @data: payload data
  * @datasz: size of payload data
  * @loginuid: loginuid of sender
+ * @sessionid: sessionid of sender
  * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int uid, int seq, void *data,



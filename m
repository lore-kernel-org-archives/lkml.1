Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZATAqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZATAqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZATAqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:46:11 -0500
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:55492 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002AbZATAqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:46:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=JbmkOoxUR5BOnn/Y5tAL71vdEMQGETcvjRLGi/VyXJsDq5HIu0oic0QMRASpi/GUv1hv4mUPtR10N2trLly+gAh/CaAolYoyy3VZ1ue7vtObU5O3PxS3U31WU3WG8qu1;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] document "nc" in addition to "netcat" in netconsole.txt
Date: Mon, 19 Jan 2009 16:46:07 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191646.07935.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It always annoyed me that the netconsole documentation didn't give me the
correct command for my distro.  Update it with a command line that actually
works on my Fedora install.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 3c2f2b3..8d02207 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -51,7 +51,8 @@ Built-in netconsole starts immediately after the TCP stack is
 initialized and attempts to bring up the supplied dev at the supplied
 address.
 
-The remote host can run either 'netcat -u -l -p <port>' or syslogd.
+The remote host can run either 'netcat -u -l -p <port>',
+'nc -l -u <port>' or syslogd.
 
 Dynamic reconfiguration:
 ========================

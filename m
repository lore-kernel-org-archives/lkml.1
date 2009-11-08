Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZKHP6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZKHP6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKHP6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:58:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:22866 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZKHP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rDMNvj2WDRixrz6VjYdvVnddRSca8Wq4+Uu5HpZmMsfrGm9p60omzVj4R5Jl1YJnXt
         CTRENNu3qqStmtluKVQqB6icDwlRdQDX0yaZFcZtMD0qNAQWwjlyUr1sx/42YPNBFy+f
         HCRN2XC8ICEP4XJYVJkt36DlJXMz5uEGEdJqk=
Date: Sun, 8 Nov 2009 19:29:23 +0330
From: Ali Gholami Rudi <ali@rudi.ir>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Patrick Ohly <patrick.ohly@intel.com>,
       linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] trivial: fix checking socket() in net tstamp example
Message-ID: <20091108155923.GA820@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
---
 .../networking/timestamping/timestamping.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/timestamping/timestamping.c b/Documentation/networking/timestamping/timestamping.c
index a7936fe..bab619a 100644
--- a/Documentation/networking/timestamping/timestamping.c
+++ b/Documentation/networking/timestamping/timestamping.c
@@ -370,7 +370,7 @@ int main(int argc, char **argv)
 	}
 
 	sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
-	if (socket < 0)
+	if (sock < 0)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));

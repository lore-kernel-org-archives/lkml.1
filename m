Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYJPRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYJPRqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbYJPRpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:45:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:21761 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbYJPRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=pdqVTBCmmW5GEOddm76Pq0f46Ci5nb4Z81UF/9CVKpujdCPNmh8OF7ZLTa9Bp16Ue7
         VhrQNFw5SDQuEhjueWfkX7E3CQY5gGgFL97Tux/gVad4DCRH2E/+QLowmHwBYglK6SrA
         EKZSNwpurEevHJlzwNdWA0wxb3tbz3a4sOndw=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 7/9] Blackfin Serial Driver: Remove BI status for known_good_char
Date: Fri, 17 Oct 2008 01:44:05 +0800
Message-Id: <1224179047-13073-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 82854d7..350bfc4 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -220,6 +220,7 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 			return;
 
  known_good_char:
+			status &= ~BI;
 			anomaly_start.tv_sec = 0;
 		}
 	}
-- 
1.5.6


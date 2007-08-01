Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbXHABlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbXHABlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXHABlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:41:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:45201 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXHABlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=iP7j6VcOoyzXoff77ID/FrwZs60NQPJvjM8GtfPcczxBkXr66e4KsFHjXuBsZMO+7xmIdti9EmPBBs3gdNZzUkiFQhLMD1ggg8fBZ/YlweH8mQpKCkoCsZ+6zY1IGWotKK/gK75brkccHhnbFkb8Symra/Lshjnr9zUNQ5JdFCc=
From: Denis Cheng <crquan@gmail.com>
To: Gabriel Craciunescu <nix.or.die@googlemail.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, chdebra@gmail.com
Subject: [PATCH] net/sched: mark "NET_CLS_RSVP6 depends on IPV6"
Date: Wed,  1 Aug 2007 09:41:31 +0800
Message-Id: <11859324914084-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/sched/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 8a74cac..5d3749c 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -300,6 +300,7 @@ config NET_CLS_RSVP
 config NET_CLS_RSVP6
 	tristate "IPv6 Resource Reservation Protocol (RSVP6)"
 	select NET_CLS
+	depends on IPV6
 	---help---
 	  The Resource Reservation Protocol (RSVP) permits end systems to
 	  request a minimum and maximum data flow rate for a connection; this
-- 
1.5.2.2


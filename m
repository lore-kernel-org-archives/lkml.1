Return-Path: <linux-kernel-owner+w=401wt.eu-S1161779AbXDYQAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161779AbXDYQAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031111AbXDYPt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:49:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031119AbXDYPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:49:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/16] AF_RXRPC: Make it possible to merely try to cancel
	timers from a module [try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 25 Apr 2007 16:49:17 +0100
Message-ID: <20070425154917.26581.19297.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070425154854.26581.97692.stgit@warthog.cambridge.redhat.com>
References: <20070425154854.26581.97692.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export try_to_del_timer_sync() for use by the AF_RXRPC module.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 kernel/timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index dd6c2c1..b22bd39 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -505,6 +505,8 @@ out:
 	return ret;
 }
 
+EXPORT_SYMBOL(try_to_del_timer_sync);
+
 /**
  * del_timer_sync - deactivate a timer and wait for the handler to finish.
  * @timer: the timer to be deactivated


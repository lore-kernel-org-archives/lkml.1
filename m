Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYJNQiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYJNQiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYJNQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:38:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60267 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751844AbYJNQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:38:16 -0400
Date: Tue, 14 Oct 2008 11:38:14 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] export clockevents_register_device
Message-ID: <20081014163814.GA1693@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the clockevents_register_device().

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/kernel/time/clockevents.c
===================================================================
--- linux.orig/kernel/time/clockevents.c	2008-10-14 11:31:17.000000000 -0500
+++ linux/kernel/time/clockevents.c	2008-10-14 11:31:40.000000000 -0500
@@ -173,6 +173,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device

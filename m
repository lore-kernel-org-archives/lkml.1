Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYJZS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYJZS3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYJZS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:28:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYJZS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:28:57 -0400
Date: Sun, 26 Oct 2008 11:29:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       davidel@xmailserver.org
Subject: kerneloops.org: 2.6.28-rc regression in epoll (list corruption)
Message-ID: <20081026112920.28e7dccc@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is upcoming fast (and I just hit it as well)

http://www.kerneloops.org/searchweek.php?search=ep_poll_callback

seems epoll grew some list corruption....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

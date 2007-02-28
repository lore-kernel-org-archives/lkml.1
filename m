Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbXB1XOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbXB1XOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXB1XOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:14:25 -0500
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:25063 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751930AbXB1XOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:14:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=aTg5lLJU6XJFHmXGP/1RaFdQWG4xfeeaDOBoqLJ7hqPY+Cw6JxGarmXFgUanygA12AZZovQqmXWzOq9FoSqmYBUfqkb0j0x//vcPeXkekXz2vaAdYXdNRzOrAz/zqYfD0JDBtqK/IDS+ZHQPs8IYzm8bcgIUDGKRBxrx5eqZN9c=  ;
X-YMail-OSG: Ki1.JRMVM1nZjI39rg6Sh2Od5ok8R8N08TGuH2o746tUP8cZXzmJMrMB_WV2hFRHrr2gQhe8Ah5QHI5IHQMUzsK0.VaO8v1lLLwZIdg7tLua6NUj_vIgVhEvjh_5xUeCWc_yZbCtnNILg_0-
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc2] parport is an orphan
Date: Wed, 28 Feb 2007 15:14:20 -0800
User-Agent: KMail/1.7.1
Cc: Andrea Arcangeli <andrea@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>, philb@gnu.org, tim@cyberelk.net
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702281514.21402.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The writing on the wall seem to be that the parport stack is orphaned,
rather than maintained by four folk ... and having a webpage that says
the latest patches are based on a 2.5 kernel.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/MAINTAINERS
===================================================================
--- g26.orig/MAINTAINERS	2007-02-28 12:46:00.000000000 -0800
+++ g26/MAINTAINERS	2007-02-28 12:47:58.000000000 -0800
@@ -2552,16 +2552,8 @@ L:	i2c@lm-sensors.org
 S:	Maintained
 
 PARALLEL PORT SUPPORT
-P:	Phil Blundell
-M:	philb@gnu.org
-P:	Tim Waugh
-M:	tim@cyberelk.net
-P:	David Campbell
-P:	Andrea Arcangeli
-M:	andrea@suse.de
 L:	linux-parport@lists.infradead.org
-W:	http://people.redhat.com/twaugh/parport/
-S:	Maintained
+S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh

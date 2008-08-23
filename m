Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYHWUuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYHWUuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYHWUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:49:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:34371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYHWUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:49:58 -0400
Date: Sat, 23 Aug 2008 13:49:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: peterz@infradeads.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Upcoming oops in lockdep
Message-ID: <20080823134955.07096e34@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in kerneloops.org a crash (slab poison) in mark_lock is coming up
rapidly: 

http://www.kerneloops.org/searchweek.php?search=mark_lock

and despite a few earlier hits on the same function it seems to be
something introduced in 2.6.27-rc... (the older ones aren't slab poison)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

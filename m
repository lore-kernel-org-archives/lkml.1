Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbXHLIMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbXHLIMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXHLIMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:12:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33558 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXHLIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:11:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BEC0AD.7080202@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 10:11:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: When to use a freezeable workqueue?
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In which situations is create_freezeable_workqueue() to be preferred
over create_singlethread_workqueue()?

Is a freezable worqueue preferable whenever the worker thread /can/ be
frozen, or is it only to be used if the thread /must/ be frozen during
suspend?

Thanks,
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/

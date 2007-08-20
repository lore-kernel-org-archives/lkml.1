Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXHTIU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXHTIU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXHTIUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:20:16 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55894 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXHTIUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:20:15 -0400
Message-ID: <46C94EB1.1070403@s5r6.in-berlin.de>
Date: Mon, 20 Aug 2007 10:20:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3-hrt2: tasklets replaced by workqueues?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got a driver bug filed against 2.6.23-rc3-hrt2 with an oops beneath
run_workqueue.  It looks a lot like another bug in mainline with a panic
beneath run_timer_softirq.  Does -hrt replace tasklets by workqueues?

http://bugzilla.kernel.org/show_bug.cgi?id=8906
http://bugzilla.kernel.org/show_bug.cgi?id=8646
-- 
Stefan Richter
-=====-=-=== =--- =---=
http://arcgraph.de/sr/

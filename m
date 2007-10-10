Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbXJJGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbXJJGyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXJJGyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:54:11 -0400
Received: from mx02.hansenet.de ([213.191.73.26]:50291 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbXJJGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:54:10 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 02:54:10 EDT
Message-ID: <470C724A.9010403@e-dict.net>
Date: Wed, 10 Oct 2007 08:33:46 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sometimes very long response times on network interfaces since 2.6.22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

since I switched to kernel 2.6.22 my dell 1750 server
with the two onboard BCM5704 network interfaces doesn't
work properly anymore.
TCP requests sometimes need more than 30 seconds to be answered
(or to get away) and the application stops with timeouts.
We are talking about two servers connected via Gigabit switch.
The timeouts happen up to ten times a day.
In the meantime I tried an old 3com 3c905c NIC which showed
the same behaviour.
I still couldn't figure out in which special situation the
communication stops.
The only solution ist to boot the old 2.6.21.5 kernel.
With this, all runs fine.
Did I miss a config issue in the migration to 2.6.22?
The machines run in a productive environment and there is
not much room (time) to debug, but if needed, I could try
if anyone would need more information for help.

Thanks - Ingo.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248Ab0AES1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0AES1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233Ab0AES1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:27:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43232 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0AES1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:27:39 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Date: Tue,  5 Jan 2010 19:27:50 +0100
Message-Id: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: Minor improvements to recordmount.pl
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while playing with ftrace and checking how it works, I also stumbled across
recordmount.pl. The following two patches contain improvements which simplify
the code and make it better readable IMHO. (They should also make it faster,
although I don't think one could measure it.)

I think there is more potential for significant speedups during build-time, but
these would involve structural changes and I'd need to do more research.

So, for a start, pick the low-hanging fruits and remove some "a bit clumsy"
parts :) I did some "unit testing" and built a complete kernel with these
patches applied. No problems, ftrace still works like a charm.

Regards,

   Wolfram


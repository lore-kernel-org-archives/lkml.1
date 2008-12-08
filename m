Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYLHWSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYLHWSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYLHWSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:18:14 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34609 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbYLHWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:18:14 -0500
Message-ID: <493D9D24.8080406@lwfinger.net>
Date: Mon, 08 Dec 2008 16:18:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: How to check for memory leaks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the best way to check if there is a memory leak?

If I start a ping running on my system using the rtl8187 driver, and nothing
else active on my system, I see an increase in the "slab" value in /proc/meminfo
of about 65 kB/minute. Is this indicative of a memory leak? When I run the same
test with p54usb, the increase is only 20 kB/min.

Thanks,

Larry


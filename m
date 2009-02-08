Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZBHRp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZBHRp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 12:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZBHRpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 12:45:49 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:58345 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZBHRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:45:49 -0500
Date: Sun, 8 Feb 2009 19:45:36 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Subject: parsing console cmdline
Message-ID: <20090208174533.GJ10711@frodo>
Reply-To: me@felipebalbi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a simple question: is it possible to register another function to decode
console= cmdline ?

I mean, I see console cmdline being decoded in
kernel/printk.c:console_setup(), but I have a special console that today
is using a platform specific TAG to be enabled and I wanna clean that up
by parsing the console via console cmdline, which makes sense. So, is it
possible that I create a special setup() function for that console of
mine ? Or should I patch console_setup() ??

-- 
balbi

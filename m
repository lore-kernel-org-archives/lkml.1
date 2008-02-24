Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYBXAqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYBXAqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBXAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:46:24 -0500
Received: from testure.choralone.org ([194.9.77.134]:58911 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYBXAqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:46:23 -0500
Date: Sat, 23 Feb 2008 19:46:15 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: boot_delay broken ?
Message-ID: <20080224004615.GA31012@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boot_delay switch seems to be behaving strangely in the
current -git.  Setting it to =10 makes the output 'bursty'
it becomes slow for some printk's whilst others scroll by
at regular speed.
Setting it any higher than that seems to make it pause for
a really long time before it outputs any text at all.

x86 timer changes perhaps ?

	Dave

-- 
http://www.codemonkey.org.uk

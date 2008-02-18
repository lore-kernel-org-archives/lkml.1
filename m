Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYBRPGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYBRPGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYBRPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:06:12 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:42625 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYBRPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:06:09 -0500
Date: Mon, 18 Feb 2008 10:05:59 -0500 (EST)
Message-Id: <6gr00g$g7mc46@smtp01.lnh.mail.rcn.net>
From: "David P. Reed" <dpreed@reed.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "David P. Reed" <dpreed@reed.com>
Subject: [patch 0/2] replacement submission for motherboard/chipset iodelay fixes
X-Junkmail-Status: score=10/50, host=mr02.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010203.47B99EDB.00F5,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2007-11-16
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the two revised patches based on Alan Cox's NAK's and suggestions
regarding using the _pic and _pit versions of inb/outb.  The new patches
use udelay(2) as a conservative delay for pic and pit, and isolate
that usage in the respective i8253.c and i8259_*.c files.
Together with the already ack'ed patch for CMOS rtc (not included here)
these should solve the problem with modern machines, the ones that don't use
older devices, but only motherboard/chipset resources.

-- 

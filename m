Return-Path: <linux-kernel-owner+w=401wt.eu-S1422925AbXBGT6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422925AbXBGT6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422928AbXBGT6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:58:30 -0500
Received: from thumper2.emsphone.com ([199.67.51.102]:49368 "EHLO
	thumper2.emsphone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422925AbXBGT63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:58:29 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 14:58:28 EST
Date: Wed, 7 Feb 2007 13:41:37 -0600
From: Andy <genanr@emsphone.com>
To: linux-kernel@vger.kernel.org
Subject: console scroll lock causes DOS
Message-ID: <20070207194137.GA25325@thumper2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the scroll lock is on and there is a bunch of console output, the machine
will eventually stop responding to the network, until scroll lock is turned
off (at sometimes that doesn't even help). 

Easy test:

hit scroll lock
do a few echo t > /proc/sysrq-trigger on that machine from a ssh/telnet session
and it should stop responding after two or three of them.

This is bad (for me) because we have a stupid switch box that uses scroll
lock to bring up the system selection menu, so sometimes scroll lock gets
left on by accident, and the machine eventually locks up.

Andy


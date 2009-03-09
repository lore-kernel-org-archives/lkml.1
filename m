Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbZCIN7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbZCIN7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZCIN7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:59:45 -0400
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:36058 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZCIN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:59:45 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 09:59:44 EDT
Date: Mon, 09 Mar 2009 09:29:36 -0400 (EDT)
From: Steve Rottinger <steve@www.rottinger.net>
Subject: Direct transfer between SCSI and PCI
To: linux-kernel@vger.kernel.org
Message-id: <36600.12.35.250.145.1236605376.squirrel@www.rottinger.net>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Importance: Normal
X-Priority: 3 (Normal)
User-Agent: SquirrelMail/1.4.8-1.fc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working with version 2.6.23 of the linux kernel on a custom PowerPC
board.  As part
of my project, I need to be able to directly transfer data from a large
buffer that resides on
a custom PCI communications device to a SCSI disk without going through
the CPU's main
memory.  Initially, it seemed like opening up the raw SCSI device in
O_DIRECT mode would
be the perfect solution.  However, through some experimentation, and
reading some posts from
a few years back, it appears that O_DIRECT only works on buffer's that
reside in processor's
main memory.   Does anyone have any suggestions as to how to get this to
work?  My environment
is pretty well controlled, so I can patch/hack the kernel without any
problem.

Thanks in advance,

-Steve




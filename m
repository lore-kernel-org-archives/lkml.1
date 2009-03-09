Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZCINWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZCINWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZCINWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:22:38 -0400
Received: from mail.pentek.com ([12.35.250.145]:3551 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751217AbZCINWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:22:38 -0400
X-Greylist: delayed 2644 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 09:22:37 EDT
Message-ID: <49B50DBE.8020100@pentek.com>
Date: Mon, 09 Mar 2009 08:38:22 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Direct transfer between SCSI and PCI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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



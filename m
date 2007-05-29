Return-Path: <linux-kernel-owner+w=401wt.eu-S1763821AbXE2UzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763821AbXE2UzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbXE2UzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:55:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33072 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752929AbXE2UzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:55:10 -0400
Date: Tue, 29 May 2007 16:55:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Sending signals to a kernel thread, broken in 2.6.22
Message-ID: <Pine.LNX.4.44L0.0705291649010.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The g_file_storage driver uses a kernel thread and communicates with
that thread in part by means of signals.  It also relies on the thread 
receiving signals from userspace as an indication that the thread 
should terminate.

This was all working in 2.6.21, but as of 2.6.22-rc3 the signal 
delivery mechanism (entirely within the kernel!) is no longer 
functional.

What's the story?  Do I need to do something new and different to get 
signals working again?  Should I avoid using signals entirely?

Thanks for any help,

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbXGJTAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbXGJTAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXGJS76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:59:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33899 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755135AbXGJS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:59:57 -0400
Date: Tue, 10 Jul 2007 14:59:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Oliver Neukum <oliver@neukum.name>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Efficient use of low-precision kernel timers
Message-ID: <Pine.LNX.4.44L0.0707101452570.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas:

Here's a question for you or anyone else who can help.

I've got a low-precision kernel timer, with a delay measured in seconds
(and rounded off to a second boundary).  Under some circumstances the
timer might be cancelled and restarted many times in quick succession
(a few thousand times perhaps).  Alternatively the timer could simply
be allowed to expire and then restarted, with the callback routine
doing a rather small amount of work.

Which is the most efficient?  Or to put it another way, how many times 
can I cancel and restart a low-precision timer before it uses up as 
much CPU time as allowing the timer to expire once?

Is there a reasonable way to answer this?  I can't think of any good 
tests.  Or is the difference in overhead so small as to be meaningless?

Alan Stern


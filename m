Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbYDQPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbYDQPWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbYDQPWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:22:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753760AbYDQPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:22:07 -0400
Date: Thu, 17 Apr 2008 11:22:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Semphore -> mutex in the device tree
Message-ID: <Pine.LNX.4.44L0.0804171117450.18040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter:

The obstacle to converting the semaphore in struct device to a mutex 
has been that its tree-oriented usage pattern isn't compatible with 
lockdep.

In order to get around this and at least begin the conversion process,
how about adding a provision for making some classes of mutex invisible
to lockdep?  I know it doesn't solve the fundamental problem, but maybe
it's a step in the right direction.

Alan Stern


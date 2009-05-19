Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZESQ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZESQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZESQ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:57:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47898 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752064AbZESQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:57:20 -0400
Date: Tue, 19 May 2009 12:57:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: How to tell whether a struct file is held by a process?
Message-ID: <Pine.LNX.4.44L0.0905191251170.10557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the best way to tell whether the current process has a
particular struct file among its open files?  Is there any better way
to find out than blindly calling fget() for each possible fd?

Is this a totally insane thing to do?

Alan Stern


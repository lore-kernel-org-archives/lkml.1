Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYBAP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYBAP1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYBAP1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:27:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36489 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752120AbYBAP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:27:46 -0500
Date: Fri, 1 Feb 2008 10:27:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Salvador Eduardo Tropea <salvador@inti.gov.ar>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Should nonblocking I/O calls to a disconnected device get an error?
 [was: Problem: hiddev stops sending events after some error recoveries]
In-Reply-To: <47A3071B.9090908@inti.gov.ar>
Message-ID: <Pine.LNX.4.44L0.0802011022430.3839-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Salvador Eduardo Tropea wrote:

> Now, I tried unplugging the device while executing a NONBLOCKing
> program. I didn't get any I/O error. It means I was wrong about the
> difference between unplugging the device and the effect of a recovery
> like the one I mentioned previously. You are right, but IMHO that's odd,
> the device should also inform I/O error when reading using a NONBLOCKing
> file handler. Currently a program must use blocking reads in order to
> get notified about the problem. It looks bad and lacks consistency. What
> do you think?

I don't know.  Other people have debated this issue in the past, but I 
can't remember what the final decision was or the reasons for it.

Alan Stern


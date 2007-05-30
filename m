Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXE3O5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXE3O5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXE3O5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:57:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57542 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752087AbXE3O5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:57:45 -0400
Date: Wed, 30 May 2007 10:57:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
In-Reply-To: <20070530123315.GA927@tv-sign.ru>
Message-ID: <Pine.LNX.4.44L0.0705301057040.2564-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Oleg Nesterov wrote:

> > Please look at
> > 
> > 	change kernel threads to ignore signals instead of blocking them
> > 	commit: 10ab825bdef8df510f99c703a5a2d9b13a4e31a5
> > 
> > I think you can convert the code above to use allow_signal().
> 
> something like untested/uncompiled patch below, what do you think?

I tried it out, and it worked perfectly.  Thank you very much.

Alan Stern


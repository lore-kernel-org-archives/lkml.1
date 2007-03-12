Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbXCLUpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbXCLUpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXCLUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:45:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752887AbXCLUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:45:05 -0400
Date: Mon, 12 Mar 2007 16:45:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <d120d5000703121331s73fa5462p5da58ba391ea7101@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703121643001.3688-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Dmitry Torokhov wrote:

> > Do you think Linus would listen if all three of us (plus maybe Greg) tried
> > to convince him?
> >
> 
> If we'd accompany the argument with the patch that changes scsi to use
> wq to perform deletion so we don't have deadlock regression in the
> kernel he might be more perceptive...

I wrote that patch over the weekend but forgot to bring it in to work.  
I'll post it tonight or tomorrow.

>  He is right about lifetime
> issues but this is not strictly lifetime issue as you correctly point
> out. Plus, refcounting also bloats the kernel so I don't relly want to
> use refcount for every integer I happen to export through sysfs if I
> can simply "revoke" access.

Agreed.

Alan Stern


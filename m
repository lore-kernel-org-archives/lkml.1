Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXGJOnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXGJOnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXGJOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:42:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47159 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754198AbXGJOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:42:53 -0400
Date: Tue, 10 Jul 2007 10:42:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <46934DC7.1020104@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707101042030.2595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Tejun Heo wrote:

> >>> A general immediate disconnect of the buffers (which will be handled in
> >>> a second pass) would be great, but doesn't sound easy.
> >> I haven't thought too hard about actual implementation but it's pretty
> >> specific case.  If doing things in generic manner is difficult, there
> >> are plenty of shortcuts to choose from, I think.
> > 
> > The "second pass" approach where the store method calls the sysfs core
> > or sets a flag or whatever sounds doable, but I'm not sure how general
> > we can get. Maybe for all store methods that just trigger an action.
> 
> Hmm... I'll give it a shot in a few days.

How would that differ from the callback technique we use now?

Alan Stern


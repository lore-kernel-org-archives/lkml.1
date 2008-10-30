Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYJ3OAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYJ3OAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbYJ3N4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:56:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56753 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756056AbYJ3N4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:56:49 -0400
Date: Thu, 30 Oct 2008 09:56:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: Miklos Szeredi <miklos@szeredi.hu>, <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
In-Reply-To: <1225371842.8576.6.camel@nigel-laptop>
Message-ID: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Nigel Cunningham wrote:

> > Well yeah, your patch handles the straightforward cases.  But it
> > doesn't help with the more tricky cases, where one fuse filesystem is
> > using another, and as those may become more widespread, this approach
> > will fail.
> 
> At the moment, yes. But it's not impossible for us to modify the patch
> to handle that as well.

It depends on what you mean.  The most direct reading of your statement
is simply wrong: It is _theoretically_ impossible to find the correct
order for freezing filesystems.  To do so would be equivalent to
solving the halting problem.

Alan Stern


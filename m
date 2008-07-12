Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYGLTzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYGLTzP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 15:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGLTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 15:55:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2157 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752502AbYGLTzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 15:55:03 -0400
Date: Sat, 12 Jul 2008 15:55:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm 1/2] kexec jump -v12: kexec jump
In-Reply-To: <m1ej5z4v7v.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0807121551590.17776-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, Eric W. Biederman wrote:

> > Forcing the second set of requests to filter through an extra software 
> > layer is a clumsy way of accomplishing this.  There ought to be a 
> > better approach.
> 
> The point was something different.  The reasons we can not store the
> state of the system with the hardware devices logically hot unplugged
> (and thus reuse all of the find device hotplug methods) is because
> things like the filesystem layer don't know how to cope with their
> block devices going away an coming back.

This is not how the procedure works.  During hibernation, block devices
are not logically hot-unplugged.  (If they were then they couldn't be
used for writing the memory image.)  Instead, they are quiesced or
suspended and their input queues are plugged.

> That is the problem inserting an virtual software device in the middle
> can solve.  If that works should there be a better way?  Certainly but
> to prove it out starting with a block device wrapper is a trivial way to
> go.

This sounds like a solution to a non-existent problem.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S942589AbYCSXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942589AbYCSXKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbYCSVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:35:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2271 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S937737AbYCSVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:35:24 -0400
Date: Wed, 19 Mar 2008 17:35:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] USB: enable USB-PERSIST by default
In-Reply-To: <47E147CD.3060102@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0803191727030.2504-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Mark Lord wrote:

> Greg Kroah-Hartman wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > This patch (as1052) enables USB-PERSIST for all devices by default.
> > The user won't have to remember to enable it explicitly for devices
> > containing mounted filesystems.
> > 
> > Eventually userspace tools like hal may be able to set the persist
> > attribute automatically when a filesystem is mounted on a USB device.
> > When that time comes this patch can be reverted, if people think it
> > matters.
> ..
> 
> Should the next word below be "that", rather than "this" ?

Yours is a rather obscure grammatical question, especially concerning a
Changelog entry (which is not even as significant to developers as a
comment, IMO).  What difference in meaning do you imagine replacing
"This" with "That" would achieve?

> > This approach has the advantage of giving the user the ability to turn
> > off USB-PERSIST for devices with mounted filesystems, rather than
> > making the kernel always assume it should be on.
> ...

What I meant (it probably wasn't very clear from the text) was that the
approach of leaving USB-PERSIST controlled by the power/persist
attribute and merely altering the attribute's default value is better
than having the kernel unilaterally and unconditionally turn
USB-PERSIST on for every device holding a mounted filesystem.  In other
words, the approach taken by the patch is better than the approach
suggested by Linus Torvalds.

Alan Stern


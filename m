Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYJ2WD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYJ2WD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYJ2WDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:03:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbYJ2WDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:03:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Wed, 29 Oct 2008 23:07:26 +0100
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org> <200810292211.49021.rjw@sisk.pl> <1225316715.18786.1.camel@nigel-laptop>
In-Reply-To: <1225316715.18786.1.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810292307.26945.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2008-10-29 at 22:11 +0100, Rafael J. Wysocki wrote:
> > The current design of the freezer is rather simplistic and I'm not really sure
> > it's the best one possible.  Perhaps we can redesign the freezer to work
> > differently and handle the cases like fuse.
> 
> Why redo what I've already done? In the full patch, you have the basis
> of what you're talking about. I haven't seen a failure to freeze fuse or
> anything else in a year of use.

Still, Miklos noticed some problems with it.

I'm not talking about doing things on top of the current signal-based
freezing mechanism, but rather about moving the freezer a bit closer towards
the scheduler.  Maybe this is the way to go.  I don't know.

In any case, the freezing of user space seems to be much simpler than modifying
all drivers to add suspend synchronization.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZEXVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZEXVFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZEXVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:05:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZEXVFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:05:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pm: remove bus_type suspend_late()/resume_early() V2
Date: Sun, 24 May 2009 23:05:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-pm@lists.linux-foundation.org,
       stern@rowland.harvard.edu, akpm@linux-foundation.org, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
References: <20090521082754.1020.73349.sendpatchset@rx1.opensource.se> <20090523212550.GA23127@suse.de> <200905240024.46567.rjw@sisk.pl>
In-Reply-To: <200905240024.46567.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905242305.35106.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009, Rafael J. Wysocki wrote:
> On Saturday 23 May 2009, Greg KH wrote:
> > On Sat, May 23, 2009 at 10:58:26PM +0200, Rafael J. Wysocki wrote:
> > > On Thursday 21 May 2009, Magnus Damm wrote:
> > > > From: Magnus Damm <damm@igel.co.jp>
> > > > 
> > > > Remove the ->suspend_late() and ->resume_early() callbacks
> > > > from struct bus_type V2. These callbacks are legacy stuff
> > > > at this point and since there seem to be no in-tree users
> > > > we may as well remove them. New users should use dev_pm_ops.
> > > 
> > > I'd like to apply this patch as is.
> > > 
> > > Greg, is it fine with you?
> > 
> > Yes, please feel free to apply this to your tree:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > or do you want me to take it in mine?  If so, no problem, just let me
> > know, and resend it.
> 
> I'll handle it, thanks!

Patch applied to the suspend-2.6 tree (linux-next branch).

Thanks,
Rafael

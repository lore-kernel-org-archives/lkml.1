Return-Path: <linux-kernel-owner+w=401wt.eu-S937818AbYCSXV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937818AbYCSXV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939298AbYCSV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:56:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761031AbYCSV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:56:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: + pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch added to -mm tree
Date: Wed, 19 Mar 2008 22:55:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
References: <Pine.LNX.4.44L0.0803191736550.2504-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803191736550.2504-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192255.29655.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Alan Stern wrote:
> On Wed, 19 Mar 2008, Greg KH wrote:
> 
> > On Wed, Mar 19, 2008 at 11:48:29AM -0700, Andrew Morton wrote:
> > > I'll drop everything, let's start again.
> > > 
> > > Only how?  umm, please review Greg's driver tree, let us know which patches
> > > shoudl be dropped from that then send new ones, I guess.
> > 
> > Yes, please do, I'm confused as well :)
> 
> Okay.  No doubt Rafael will correct me if I get something wrong.
> 
> Greg's tree still contains the original, wrong version of 
> pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch.  It 
> should be reverted.  In its place should be substituted this series of 
> patches (URLs for 0/3 ... 3/3):
> 
> 	http://marc.info/?l=linux-kernel&m=120561808422302&w=2
> 	http://marc.info/?l=linux-kernel&m=120561808522316&w=2
> 	http://marc.info/?l=linux-kernel&m=120561808522322&w=2
> 	http://marc.info/?l=linux-kernel&m=120561808622328&w=2
> 
> There is likely to be a conflict in applying the 2/3 patch, because its 
> first hunk touches a region of code also affected by work Rafael has 
> been doing.  The important aspect of that hunk is that it moves the 
> should_wakeup flag definition outside the region protected by "#ifdef 
> CONFIG_PM_SLEEP".

I've just resent the three patches, rebased on top of the current tree.

Please double check if everytning is right.

Thanks,
Rafael

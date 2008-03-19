Return-Path: <linux-kernel-owner+w=401wt.eu-S939143AbYCSXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939143AbYCSXTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763393AbYCSVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:46:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2300 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933620AbYCSVqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:46:55 -0400
Date: Wed, 19 Mar 2008 17:46:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: + pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch
 added to -mm tree
In-Reply-To: <20080319185755.GA18464@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0803191736550.2504-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Greg KH wrote:

> On Wed, Mar 19, 2008 at 11:48:29AM -0700, Andrew Morton wrote:
> > I'll drop everything, let's start again.
> > 
> > Only how?  umm, please review Greg's driver tree, let us know which patches
> > shoudl be dropped from that then send new ones, I guess.
> 
> Yes, please do, I'm confused as well :)

Okay.  No doubt Rafael will correct me if I get something wrong.

Greg's tree still contains the original, wrong version of 
pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch.  It 
should be reverted.  In its place should be substituted this series of 
patches (URLs for 0/3 ... 3/3):

	http://marc.info/?l=linux-kernel&m=120561808422302&w=2
	http://marc.info/?l=linux-kernel&m=120561808522316&w=2
	http://marc.info/?l=linux-kernel&m=120561808522322&w=2
	http://marc.info/?l=linux-kernel&m=120561808622328&w=2

There is likely to be a conflict in applying the 2/3 patch, because its 
first hunk touches a region of code also affected by work Rafael has 
been doing.  The important aspect of that hunk is that it moves the 
should_wakeup flag definition outside the region protected by "#ifdef 
CONFIG_PM_SLEEP".

Alan Stern


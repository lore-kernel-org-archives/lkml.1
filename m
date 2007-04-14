Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXDNIeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXDNIeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXDNIeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:34:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55984 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXDNIen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:34:43 -0400
Date: Sat, 14 Apr 2007 01:34:10 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
Message-ID: <20070414083410.GU6602@sequoia.sous-sol.org>
References: <46206842.80203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46206842.80203@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rene Herman (rene.herman@gmail.com) wrote:
> Stumbling around with git here. I'd like to use git to efficiently track 
> the current -stable as well as -current. Say, my local tree is a clone of 
> Linus current:
> 
> git clone \ 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git local
> 
> I then branch off a 2.6.20 branch:
> 
> cd local
> git checkout -b v2.6.20 v2.6.20
> 
> to now update to the current -stable I could do:
> 
> git pull \ 
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

I've already put a tree like this up on kernel.org.  The master branch
is Linus' tree, and there's branches for each of the stable releases
called linux-2.6.[12-20].y (I didn't add 2.6.11.y).

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary

> each time that a new -stable is released. Rather though, I'd like a simple 
> "git pull" to do this while on this branch while a "git pull" while back on 
> the master branch pulls from the originally cloned Linus repo again.

You have to be careful with pull.  It will always want to merge onto your
current branch.

thanks,
-chris

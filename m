Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYILTI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYILTI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYILTIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:08:19 -0400
Received: from ns.suse.de ([195.135.220.2]:54841 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbYILTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:08:18 -0400
Date: Fri, 12 Sep 2008 08:51:05 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: kobject leak in next-20080829 (and mainline)
Message-ID: <20080912155105.GA3526@suse.de>
References: <20080830044246.GA26435@x200.localdomain> <20080830054343.GA16899@suse.de> <20080906054522.GA3191@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906054522.GA3191@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 09:45:22AM +0400, Alexey Dobriyan wrote:
> On Fri, Aug 29, 2008 at 10:43:43PM -0700, Greg KH wrote:
> > On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> > > 	size-32: 3511 kvasprintf+0x57/0x90
> > > 	size-64: 3059 kobject_create+0x1c/0x40
> > > 
> > > These two buddies increase after every "modprobe; rmmod" sequence.
> > 
> > Do they also do so in mainline?
> 
> Yep, same bug in mainline.

Not good.  Does 2.6.26 show this as well?

thanks,

greg k-h

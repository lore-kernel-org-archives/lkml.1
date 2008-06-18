Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYFRQFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYFRQFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYFRQFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:05:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYFRQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:05:43 -0400
Date: Wed, 18 Jun 2008 09:02:23 -0700
From: Greg KH <greg@kroah.com>
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Cc: "'Jason Baron'" <jbaron@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, joe@perches.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 0/8] dynamic debug
Message-ID: <20080618160223.GA9453@kroah.com>
References: <20080613185733.GA8813@redhat.com> <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 11:26:12AM +0900, Takashi Nishiie wrote:
> Hi.
> 
> Jason Baron wrote:
> >Each kernel sub-system seems to have its own way of dealing with 
> >debugging statements. Some of these methods include 'dprintk', 
> >'pr_debug', 'dev_debug', 'DEBUGP'. There are also a myriad of 
> >ways of enabling these statements. 
> 
>  I propose to replace 'Pr_debug', 'Dev_debug', and 'DEBUGP' with 
> kernel markers. SystemTap is used for the output of the log.  

That would be a nice goal, but how are you going to handle dynamic
strings?

>  I propose to make it to the function to output only specified 
> kernel markers as a log and the function in a word like LTTng of
> a simple version by using the framework and kernel markers of 
> ftrace if the log is output by using debugfs. 

It might be a nice long term goal, but this patchset is a much simpler
approach for this time, not requiring systemtap or any external tool-set
to be installed and set up properly.

thanks,

greg k-h

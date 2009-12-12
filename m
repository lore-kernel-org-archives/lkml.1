Return-Path: <linux-kernel-owner+w=401wt.eu-S934009AbZLMBn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbZLMBn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933911AbZLMBn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:43:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45375 "HELO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933894AbZLMBn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:43:26 -0500
Date: Fri, 11 Dec 2009 22:46:20 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb_autopm_*() removal build failure...
Message-ID: <20091212064620.GA13405@suse.de>
References: <20091211.174551.123151540.davem@davemloft.net> <20091212040524.GA11212@suse.de> <20091211.214714.41966763.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211.214714.41966763.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 09:47:14PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Fri, 11 Dec 2009 20:05:24 -0800
> 
> > Here's the patch, sent back in August:
> > 	 http://marc.info/?l=linux-netdev&m=125071045301270&w=2
> > 
> > Can you take it from there, or do you need me to forward it on?
> 
> I tossed this into the net-2.6 tree, but...
> 
> I would recommend that in the future when you have the
> dependency of an API change that's going to break the
> build, you take in the necessary change.  And you make
> sure such a commit is in your tree before the commit
> that removes the API.

I did at first, so I dropped the API change from my tree.  Then Alan and
Oliver pointed out that the changes were already in your tree, and I
looked and saw the first one, so just assumed the 2 other ones were
there, and turned off all network USB drivers in my build in order to
handle this.

Then yesterday, Stephen reported that this one driver failed to build,
which I didn't pick up on until today, after the tree had been sent to
Linus.

So, a mixup on my part, I'm sorry about that.

> Anyways, next time, please resolve API issues internally when you
> do things that will break the build otherwise.

Will do.

thanks for your patience.

greg k-h

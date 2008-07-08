Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYGICad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYGICad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 22:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGICaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 22:30:24 -0400
Received: from ns.suse.de ([195.135.220.2]:50875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYGICaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 22:30:24 -0400
Date: Mon, 7 Jul 2008 21:12:39 -0700
From: Greg KH <gregkh@suse.de>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.10
Message-ID: <20080708041239.GB4099@suse.de>
References: <20080703035807.GA8190@kroah.com> <e2e108260807031008r3de9aad7v8222d41fd750b9da@mail.gmail.com> <20080703172914.GA11123@suse.de> <e2e108260807050054v44323b97s6bfbd0371beef51e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260807050054v44323b97s6bfbd0371beef51e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 09:54:22AM +0200, Bart Van Assche wrote:
> On Thu, Jul 3, 2008 at 7:29 PM, Greg KH <gregkh@suse.de> wrote:
> > The release notes are there in the shortlog in the email announcement
> > and full Changelog on the kernel.org site for exactly what specifically
> > was fixed:
> >        http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.25.10
> >
> > If you have any specific questions about any of the individual changes,
> > please let us, and the developers who made those fixes know.
> 
> Sometimes I have to backport bugfixes to older kernels. In that case
> it's important to know in which kernel version the bug was introduced.
> This info is included for some of the bugfix patches in the changelog,
> but not for all.

That's because sometimes no one digs through the code to find this out.
I would recommend using 'git blame' to determine this if it is something
that you need to have.

But for the most part, -stable doesn't really care about older kernel
versions, we have to draw the line somewhere, sorry.

thanks,

greg k-h

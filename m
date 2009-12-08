Return-Path: <linux-kernel-owner+w=401wt.eu-S966912AbZLHXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966912AbZLHXEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966592AbZLHXEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:04:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:56098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966573AbZLHXEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:04:21 -0500
Date: Tue, 8 Dec 2009 15:01:58 -0800
From: Greg KH <gregkh@suse.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@kernellabs.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: 2.6.27.40 build error
Message-ID: <20091208230158.GA22129@suse.de>
References: <20091208214246.GA21857@kroah.com>
 <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 04:49:14PM -0500, Devin Heitmueller wrote:
> On Tue, Dec 8, 2009 at 4:42 PM, Greg KH <greg@kroah.com> wrote:
> > It turns out that the patch below causes a build failure on the
> > 2.6.27.40 kernel.
> >
> > Michael, should I just drop it, or should I take out the line with the
> > "capture_transfer_done" in it, as that member is not in the structure in
> > this kernel version.
> >
> > thanks,
> >
> > greg k-h
> 
> There were several different leaks and crash conditions addressed
> since 2.6.27, and it is entirely possible that just removing the line
> is not the correct course of action.
> 
> I would propose just dropping the patch for 2.6.27, as we would have
> to rework it taking into consideration the other fixes which were done
> since then.

Ok, I'll go do that.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0BRBPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab0BRBPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:15:01 -0500
Date: Wed, 17 Feb 2010 17:12:49 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Brown <neilb@suse.de>, Greg KH <greg@kroah.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate  between locking links and
 non-links
Message-ID: <20100218011248.GA2393@suse.de>
References: <19314.1869.847327.15190@notabene.brown>
 <20100210230625.GB678@suse.de>
 <m1fx57zbyl.fsf@fess.ebiederm.org>
 <20100211223235.GC30430@suse.de>
 <m1bpfvz8wy.fsf@fess.ebiederm.org>
 <20100217223848.GA31557@kroah.com>
 <20100218113912.4a3d36e9@notabene.brown>
 <m18warpda9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18warpda9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 05:01:50PM -0800, Eric W. Biederman wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > On Wed, 17 Feb 2010 14:38:48 -0800
> > Greg KH <greg@kroah.com> wrote:
> 
> >> Got it, I've fixed this by hand.
> >> 
> >>
> >
> > Thanks.
> > I hadn't sent you a fix myself (As requested) as I got the impression from
> > the following discussion that a different approach would be taken.
> >
> > I'm happy either way though.
> 
> I had the same impression.
> 
> For simplicity I didn't base my patches on Neils because I would just
> have had to undo it when I modified directories and symlinks to not
> mess with s_active.

Argh, sorry about that, I'll go drop Neil's patch and queue up Eric's
instead.  I was working my way through the patch queue and hadn't gotten
to Eric's just yet...

thanks,

greg k-h

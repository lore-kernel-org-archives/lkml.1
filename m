Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZHFXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZHFXh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZHFXh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:37:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:38040 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZHFXhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:37:25 -0400
Date: Thu, 6 Aug 2009 16:32:08 -0700
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: drivers/staging/meilhaus build broken with ftrace
Message-ID: <20090806233208.GA29339@suse.de>
References: <ada4oskfwtp.fsf@cisco.com>
 <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com>
 <20090806222906.GA14792@suse.de>
 <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com>
 <adamy6ceeig.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamy6ceeig.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 03:58:15PM -0700, Roland Dreier wrote:
> 
>  > Now the question is, is this a crucial enough change to push for 31, or 
>  > should we leave this for 32?
> 
> I would say yes, push it for 31, since a distro is most likely going to
> want to enable staging drivers and ftrace, and will hit this build
> breakage.
> 
>  > This patch is small enough for 31, but to add a warning would require a 
>  > little more code rework. I can queue this up for 31 and then have the 
>  > warning ready for 32.
> 
> Sounds like a good plan.  The warning will probably push someone to
> figure out what the meilhaus code is really trying to do.

I agree, that's fine with me.

thanks,

greg k-h

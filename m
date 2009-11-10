Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZKJV2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZKJV2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZKJV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:28:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZKJV2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:28:02 -0500
Date: Tue, 10 Nov 2009 13:25:01 -0800
From: Greg KH <gregkh@suse.de>
To: Junio C Hamano <gitster@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110212501.GA13558@suse.de>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de>
 <20091110193919.GC12686@suse.de>
 <20091110204537.GB18509@elte.hu>
 <7vhbt23x1m.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vhbt23x1m.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:11:17PM -0800, Junio C Hamano wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > Yeah. This new tagging scheme doesnt really allow anything 'new' per se 
> > - it just helps the existing practice some more. All these commits were 
> > -stable candidates anyway, in exactly the same order - the only 
> > difference the new tagging scheme adds here is a more organized, 
> > in-upsream-Git way of communicating it to you.
> 
> I am just a bystander, but if it were truly in-upstream-git way, wouldn't
> you be forking a branch from the tagged target release (the latest of
> 2.6.32.X), and queuing only the changes meant for -stable to it, and
> giving the name of the branch to git people and sending out patches from
> that branch for e-mailed review and application?
> 
> There won't be any special tagging required, only a dedicated branch.
> 
> Or am I missing something?

Yes, these are patches going to Linus's tree, which would be 2.6.33 at
the time.  I need to know the ids to add them back to the older .32.y
tree.

hope this helps,

greg k-h

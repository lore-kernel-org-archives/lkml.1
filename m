Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYGYXoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYGYXoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYGYXop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:44:45 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:39031 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752193AbYGYXop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:44:45 -0400
Date: Fri, 25 Jul 2008 19:44:43 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: git snapshots (Was: Re: merging branches remotely with git?)
Message-ID: <20080725234443.GA10681@bromo.msbb.uc.edu>
References: <20080725112231.GA28411@digi.com> <1216986122.7098.36.camel@muff>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1216986122.7098.36.camel@muff>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Does anyone know what kernel sources the my-wireless-testing git
is based on? If it is based on the stock 2.6.26 release with only
wireless specific patches, perhaps I could just diff it against 
2.6.26 to extract the patches needed for ath9k support? I would
rather stick to the stable git releases of 2.6.26 for now with
the minimum patches applied to get ath9k working on my MacBook Pro.
                   Jack


On Fri, Jul 25, 2008 at 12:42:02PM +0100, Mark McLoughlin wrote:
> On Fri, 2008-07-25 at 13:22 +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > > ps Which git represents the git patches (like 2.6.26-git11) which are
> > > placed as patches on the www.kernel.org web page under the section
> > > The latest snapshot for the stable Linux kernel tree is:.
> > AFAIK there is no public tree that contains these tags.  But I have a
> > little script that creates them.  See below.
> 
> Yeah, a public repo on git.kernel.org containing only the snapshot tags
> would be immensely useful.
> 
> e.g. Fedora rawhide regularly ships snapshots, so it'd be really nice to
> be easily look-up what's been merged since a given snapshot:
> 
>   $> git-fetch linus
>   $> git-fetch snapshot-tags
>   $> git-log v2.6.26-git12..linus/master
> 
> (That is, assuming the snapshot script couldn't just push the tags to
> Linus's repo ...)
> 
> Cheers,
> Mark.

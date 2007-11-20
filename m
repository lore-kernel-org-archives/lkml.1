Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbXKTROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbXKTROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXKTRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:13:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734AbXKTRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:13:52 -0500
Date: Tue, 20 Nov 2007 09:04:20 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       David <david@unsolicited.net>
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120170420.GA15954@kroah.com>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <20071118005538.GD26865@elte.hu> <47422AA3.7060507@redhat.com> <20071120060808.GG20436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120060808.GG20436@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 07:08:08AM +0100, Ingo Molnar wrote:
> 
> * Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > On 11/17/2007 07:55 PM, Ingo Molnar wrote:
> > > * Greg KH <greg@kroah.com> wrote:
> > > 
> > >> Great, thanks for tracking this down.
> > >>
> > >> Ingo, this corrisponds to changeset 
> > >> a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch 
> > >> incorrect?  Should this patch in the -stable tree be reverted?
> > > 
> > > hm, there are no such problems in .24 and the cpu_clock() and other 
> > > fixes i did were not picked up. Find the missing fixes below. They 
> > > should work just fine in .23 as it has the cpu_clock() functionality 
> > > too.
> > > 
> > > [ NOTE: the most robust thing is to make the .23 version match the .24
> > >   version of kernel/softlockup.c, so i included two other harmless
> > >   changes in this diff as well. ]
> > > 
> > > 	Ingo
> > > 
> > > ----------->
> > > commit a5f2ce3c6024a5bb895647b6bd88ecae5001020a
> > > Author: Ingo Molnar <mingo@elte.hu>
> > > Date:   Tue Oct 16 23:26:08 2007 -0700
> > > 
> > > commit 43581a10075492445f65234384210492ff333eba
> > > Author: Ingo Molnar <mingo@elte.hu>
> > > Date:   Tue Oct 16 23:26:08 2007 -0700
> > 
> > Those are just cosmetic / cleanup changes.
> > 
> > Don't you need commit a3b13c23f186ecb57204580cc1f2dbe9c284953a ??
> 
> yes:
> 
> > > [...] the cpu_clock() and other fixes i did were not picked up.
> 
> i just forgot to attach the cpu_clock() changes - they are in a3b13c23.

Ok, I've now added that patch too :)

Hopefully this is all straightened out now, I'll go cut a -rc for the
next stable so people can test...

thanks,

greg k-h

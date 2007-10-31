Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbXJaOwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbXJaOwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbXJaOv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:51:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbXJaOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:51:55 -0400
Date: Wed, 31 Oct 2007 07:37:51 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, stable <stable@kernel.org>,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] lockdep: fix mismatched
	lockdep_depth/curr_chain_hash
Message-ID: <20071031143751.GA7153@kroah.com>
References: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net> <1191576686.22357.64.camel@twins> <20071008172424.GA6692@kroah.com> <1191864970.5797.1.camel@lappy> <20071008173908.GA26121@kroah.com> <1193334482.6914.23.camel@twins> <4720E689.9050509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720E689.9050509@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 02:55:05PM -0400, Chuck Ebbert wrote:
> On 10/25/2007 01:48 PM, Peter Zijlstra wrote:
> > On Mon, 2007-10-08 at 10:39 -0700, Greg KH wrote:
> >> On Mon, Oct 08, 2007 at 07:36:10PM +0200, Peter Zijlstra wrote:
> >>> On Mon, 2007-10-08 at 10:24 -0700, Greg KH wrote:
> >>>> On Fri, Oct 05, 2007 at 11:31:26AM +0200, Peter Zijlstra wrote:
> >>>>> Stable team,
> >>>>>
> >>>>> please consider this patch for the next 22-stable.
> >>>> I don't see this patch in Linus's upstream tree.  We need it there to be
> >>>> able to accept it for -stable.  Or is this just a bugfix of other things
> >>>> that are already in his tree?
> >>> I send Linus a similar patch, haven??t seem him pick it up yet.
> >>> I??ll notify you when and if he picks it up.
> >> Great, that would be great for us -stable monkeys...
> > 
> > 3aa416b07f0adf01c090baab26fb70c35ec17623
> > 
> > 
> 
> And for both 2.6.22 and 2.6.23...

It does not apply to 2.6.22 at all, so unless someone sends us a
backported version, I'll not apply it there.

thanks,

greg k-h

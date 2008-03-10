Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYCJUcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYCJUcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYCJUch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:32:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55209 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYCJUcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:32:36 -0400
Date: Mon, 10 Mar 2008 13:31:16 -0700
From: Greg KH <greg@kroah.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: inotify fixes in stable
Message-ID: <20080310203116.GC5943@kroah.com>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <20080310160317.GB20775@kroah.com> <20080310203658.3bdbc27c@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310203658.3bdbc27c@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 08:36:58PM +0100, Pierre Ossman wrote:
> On Mon, 10 Mar 2008 09:03:17 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Mar 10, 2008 at 09:11:55AM +0100, Pierre Ossman wrote:
> > > Hi Greg,
> > > 
> > > I was hoping that the fixes for bug 7785 "BUG: at fs/inotify.c:172
> > > set_dentry_child_flags()" could be added to the stable releases. I'm
> > > seeing these quite frequently at customer installations.
> > 
> > In the future, stable stuff should be sent to the stable@kernel.org
> > email address and not directly to me, thanks.
> > 
> 
> Sorry. :/
> 
> > > The relevant commits are d599e36a9ea85432587f4550acc113cd7549d12a and
> > > 0d71bd5993b630a989d15adc2562a9ffe41cd26d. Hopefully these do not
> > > depend on other updates. Nick would be the expert on that.
> > 
> > Can you verify that if you apply just those 2 patches to the latest
> > 2.6.24.3 kernel release, it fixes the issues for you?
> > 
> 
> The system is an OpenSuse 10.3 system, so 2.6.22.y would be the
> interesting one. I'll see if I can get a custom kernel in there (I've
> been unable to reproduce the problem outside a production
> environment).

2.6.22.y is no longer being released by me, so it isn't interesting to
me at all :)

What about 2.6.24?  Is this still an issue there?

thanks,

greg k-h

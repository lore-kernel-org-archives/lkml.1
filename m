Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYBWG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYBWG3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYBWG3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:29:30 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45466 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYBWG33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:29:29 -0500
Date: Sat, 23 Feb 2008 07:29:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, jejb@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [stable] [patch 34/38] kbuild: allow -fstack-protector to take effect
Message-ID: <20080223062939.GA11207@uranus.ravnborg.org>
References: <20080223001946.979768610@mini.kroah.org> <20080223003133.GI7268@suse.de> <20080222164617.50c8ec2e@laptopd505.fenrus.org> <20080223005349.GA30744@suse.de> <20080223034115.GA9937@uranus.ravnborg.org> <20080223035356.GB25980@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223035356.GB25980@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 07:53:56PM -0800, Greg KH wrote:
> On Sat, Feb 23, 2008 at 04:41:15AM +0100, Sam Ravnborg wrote:
> > On Fri, Feb 22, 2008 at 04:53:49PM -0800, Greg KH wrote:
> > > On Fri, Feb 22, 2008 at 04:46:17PM -0800, Arjan van de Ven wrote:
> > > > On Fri, 22 Feb 2008 16:31:33 -0800
> > > > Greg KH <gregkh@suse.de> wrote:
> > > > 
> > > > > 2.6.24-stable review patch.  If anyone has any objections, please let
> > > > > us know.
> > > > 
> > > > 
> > > > not ready for -stable yet. if ever for backporting (doubtful)
> > > 
> > > Ok, dropped from -stable, thanks.
> > 
> > For the record I agree with Arjan that it is not yet -stable ready.
> 
> Ok.  Then who sent this to the stable alias in the first place?
> 
> Sam, you added the "cc: stable@kernel.org" to the patch, and that caused
> it to be sent to us when it went into Linus's tree.  If you don't want
> things like this to go into the -stable tree, don't mark it as such :)

When I added the tag I was convinced this was -stable material.
Only later the testing done by James revealed that this was bogus
and I had long forgotten I added -stable to the patch.

	Sam

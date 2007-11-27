Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbXK0V0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbXK0V0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXK0V02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:26:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbXK0V01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:26:27 -0500
Date: Tue, 27 Nov 2007 16:25:58 -0500
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127212558.GA27481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sam@ravnborg.org
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com> <200711261228.15155.rusty@rustcorp.com.au> <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> <20071127190037.GB30057@redhat.com> <20071127210942.GF3406@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127210942.GF3406@stusta.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:09:42PM +0100, Adrian Bunk wrote:
 > On Tue, Nov 27, 2007 at 02:00:37PM -0500, Dave Jones wrote:
 > > On Mon, Nov 26, 2007 at 10:25:33AM -0800, Stephen Hemminger wrote:
 > >  
 > >  > 1) Why is everyone so concerned that export symbol space is large?
 > >  > 	- does it cost cpu or running memory?
 > >  > 	- does it cause bugs?
 > >  > 	- or are you just worried about "evil modules"?
 > > 
 > > To clarify something here, by "evil", don't necessarily think "binary only". 
 > > 
 > > Out of tree modules are frequently using symbols that they shouldn't be.
 > > Because they get no peer-review here, they 'get away with it' for the most part.
 > > Until distro vendors push rebased kernel updates that removed exports that
 > > should never have been exported, and suddenly people like me get bombed
 > > with "Fedora broke my xyz driver" mails.
 > >...
 > 
 > The real problem is that these drivers are not in the upstream kernel.

You're preaching to the choir.

 > Are there common reasons why these drivers are not upstream?

It varies case by case.

	Dave

-- 
http://www.codemonkey.org.uk

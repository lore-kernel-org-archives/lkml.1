Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZCKAfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZCKAfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZCKAff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:35:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:36726 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZCKAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:35:35 -0400
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gaudenz Steinlin <gaudenz@soziologie.ch>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903110004.04450.rjw@sisk.pl>
References: <20090304083859.GB6889@soziologie.ch>
	 <20090310213027.GB6272@soziologie.ch> <1236722866.7086.12.camel@pasglop>
	 <200903110004.04450.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 11:34:53 +1100
Message-Id: <1236731693.7086.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 00:04 +0100, Rafael J. Wysocki wrote:
> On Tuesday 10 March 2009, Benjamin Herrenschmidt wrote:
> > On Tue, 2009-03-10 at 22:30 +0100, Gaudenz Steinlin wrote:
> > > Are you still interested in these tests after that disabling the early
> > > resume hack fixed things? I can try my best to test and add printk's
> > > but
> > > it will probably take some time because I can't constantly reboot my
> > > computer and still do some usefull work...
> > > 
> > No thanks, I think the initial test with early resume was flawed due to
> > something like having cpufreq disabled.
> 
> Well, I've lost track a bit.
> 
> Which patch is going to be the final fix?

I sent it to Linus as part of a pull request, it removes my early resume
hooks for now, I'll look into fixing them after .29

Cheers,
Ben.



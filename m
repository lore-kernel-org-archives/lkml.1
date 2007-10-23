Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbXJWOtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbXJWOtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJWOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:48:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbXJWOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:48:55 -0400
Date: Tue, 23 Oct 2007 16:48:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071023144852.GA27956@one.firstfloor.org>
References: <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023142006.GA9961@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 04:20:06PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >> You should rename it then to "asmcall" or something.
> > >
> > > if then that should be a separate renaming patch.
> > 
> > Well you're asking for the ugly hacks for out of tree code.  [...]
> 
> nice word-bending there. I'm asking for pre-existing annotations to 
> survive. 

What I'm objecting to is that you ask for this for your out of 
tree code without any justification on why exactly -- -pg should
in theory work with -mregparms. 

It's standard policy to require very good reasons for changes
that are only useful for out of tree code.  People get flamed
for this all the time so I'm doing this thankless job here too.

Is it just because you didn't want to adapt the tracer for i386 regparm?
(that would be an invalid reason in my opinion ;-)
The correct fix would be to adapt the tracer then.

Or is it because gcc miscompiles something on i386 with -mregparm -pg?
(if yes that would be a valid reason, but it should be clearly stated) 

-Andi


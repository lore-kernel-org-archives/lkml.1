Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZHYAdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZHYAdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZHYAdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbZHYAdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:33:13 -0400
Date: Mon, 24 Aug 2009 20:33:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Dick Streefland <dick@streefland.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: manual merge of the kconfig tree with the kbuild
 tree
In-Reply-To: <20090825094427.b91e3329.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.0908242032210.6710@gandalf.stny.rr.com>
References: <20090824113226.b61cccc6.sfr@canb.auug.org.au> <20090824083433.GA6147@streefland.net> <alpine.DEB.2.00.0908241052420.7587@gandalf.stny.rr.com> <20090825094427.b91e3329.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Aug 2009, Stephen Rothwell wrote:

> Hi Steve,
> 
> On Mon, 24 Aug 2009 10:54:04 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon, 24 Aug 2009, Dick Streefland wrote:
> > 
> > > My simplified script that you merged from the kbuild tree will also
> > > extract config information from ELF files. So both patches from the
> > > kconfig tree are not needed anymore.
> > 
> > OK what is the proper way to resolve this, before sending anything off to 
> > Linus?  Should I pull in Dick's tree and resolve the conficts myself, and 
> > let you repull? Or is something else recommended?
> 
> You could cherry-pick Dick's commit into your tree (and remove your
> conflicting commits by rebasing). Or you could rebase your work on top of
> Sam's kbuild tree (or merge Sam's tree) (but that would require Sam to
> guarantee that his tree won't be rebased). Or you could do the rebase and
> then just submit your tree to Sam for inclusion (instead of, or as well
> as, it being included in linux-next directly).  Or you could keep going
> the way you are and resolve the conflict once one of the trees has been
> merged into Linus' tree.
> 
> For the moment, I can keep resolving the conflict.

Yeah, lets just keep it as is for the moment. When Sam's is accepted into 
Linus's I'll rebase off of that. Assuming that Sam's will be accepted 
rather quickly ;-)

-- Steve


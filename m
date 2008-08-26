Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbYHZUye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbYHZUye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbYHZUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:53:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbYHZUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:53:57 -0400
Date: Tue, 26 Aug 2008 16:53:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: only warn once on old objcopy and local
 functions
In-Reply-To: <20080826154721.9416e2e9.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0808261652470.17093@gandalf.stny.rr.com>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu> <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com> <20080825190103.GA24029@elte.hu> <20080826094627.5d627b5b.sfr@canb.auug.org.au> <20080826115113.806cfe23.sfr@canb.auug.org.au>
 <alpine.DEB.1.10.0808252324050.966@gandalf.stny.rr.com> <20080826154721.9416e2e9.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 Aug 2008, Stephen Rothwell wrote:

> Hi Steve,
> 
> On Mon, 25 Aug 2008 23:25:25 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >   Stephen, can you try to see if this works for you, with the
> >   issue of spamming warnings?
> 
> I get no warnings at all.  I think this is because I always build with
> O=... so that the way you find $topdir (and therefore the .version file)
> does not work.

Hmm, Well we don't need the warning, although it would be nice to give. 
There seems to be a lot of hacking to get a warning for this. Perhaps
we just ignore the local functions and not warn at all?

-- Steve


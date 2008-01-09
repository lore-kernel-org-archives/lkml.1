Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYAIWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYAIWjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYAIWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:39:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYAIWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:39:09 -0500
Date: Wed, 9 Jan 2008 23:41:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109224142.GB18480@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org> <20080109220948.GA2218@atjola.homenet> <20080109222804.GF15612@one.firstfloor.org> <1199918155.6424.71.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199918155.6424.71.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:35:55PM -0800, Harvey Harrison wrote:
> On Wed, 2008-01-09 at 23:28 +0100, Andi Kleen wrote:
> 
> > Do you have a simple recipe to just update from the the remote branch,
> > assuming there are no local changes or local branches? 
> > 
> > -Andi
> 
> For staying up to date I use the following:
> 
> # Add Linus's tree as a remote
> git remote --add linus
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> # Add Ingo's tree as a remote
> git remote --add x86
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> # With that setup, just run the following to get any changes you
> # don't have.  It will also notice any new branches Ingo/Linus
> # add to their repo.  Look in .git/config afterwards, the format
> # to add new remotes is easy to figure out.
> git remote update

I'm already cloning the branches; the problem is not getting conflicts etc.
when updating.

-Andi

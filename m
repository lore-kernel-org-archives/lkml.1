Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYENRwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYENRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYENRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:51:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762352AbYENRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:51:08 -0400
Date: Wed, 14 May 2008 10:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       ron.rindjunsky@intel.com, sfr@canb.auug.org.au, tomas.winkler@intel.com,
       git@vger.kernel.org
Subject: Re: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to
 -mm tree
Message-Id: <20080514105042.12a112e4.akpm@linux-foundation.org>
In-Reply-To: <20080514123432.GB3349@tuxdriver.com>
References: <200805140405.m4E45oBc015343@imap1.linux-foundation.org>
	<20080513.213927.191790810.davem@davemloft.net>
	<20080513215737.fe1bdebd.akpm@linux-foundation.org>
	<20080513.221529.20855966.davem@davemloft.net>
	<20080514123432.GB3349@tuxdriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 08:34:32 -0400 "John W. Linville" <linville@tuxdriver.com> wrote:

> On Tue, May 13, 2008 at 10:15:29PM -0700, David Miller wrote:
> 
> > I used to play this game, it's a lot of work and it sucks.  One
> > "drib" can require fixing up 200 patches down the chain.  And
> > I've had this happen to me all the time in the past when I was
> > rebasing all the time.
> 
> I have to agree with Dave.
> 
> Moreover, I used to get regular complaints about the old "regular
> rebase" process.  We switched to a "pull and merge" process for 2.6.25,
> and in that period nearly all of the process-related complaints
> disappeared for me.
> 

Well.  Have you ever been an hour and a half into a bisection at 3AM
then hit a massive oops deep in the TCP code which was spread across a
large number of commits?  I have and it wasn't fun.  iirc I gave up and
went to bed.

> To some degree this is a "pick your poison" issue, and for most people
> rebasing seems like the deadlier poison.

Well yes.  We'd like the best of both worlds, only we cannot have it. 
And the sole _reason_ we cannot have it is due to restrictions in git
<stimulate, stimulate>.

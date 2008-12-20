Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYLTW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYLTW3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 17:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYLTW3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 17:29:32 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59388 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYLTW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 17:29:31 -0500
Date: Sat, 20 Dec 2008 23:31:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/26] kbuild: support switching source directories with O=.. builds
Message-ID: <20081220223102.GA3390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org> <1229783497-19550-26-git-send-email-sam@ravnborg.org> <20081220163423.GR25779@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220163423.GR25779@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 05:34:23PM +0100, Andi Kleen wrote:
> On Sat, Dec 20, 2008 at 03:31:37PM +0100, Sam Ravnborg wrote:
> > It was not possible to use the same output directory
> > for two different source repositories becuase the asm
> > symlink in include2/asm would point to the first repository.
> > 
> > We now create the symlink each time thus allowing switch
> > between different source repositories.
> > 
> > This feature was requested by Andi Kleen.
> 
> Thanks. But it's not really a new feature, this used to work and just
> broke at some point. I would consider it a regression fix.

I will reword if I need to rebase anyway.

But that said it has never been a planned feature
and with a single report of broken behaviour so far
it is not widely used. In other words not stable
material etc.

	Sam

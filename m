Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZFDUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZFDUDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZFDUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:03:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFDUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:03:11 -0400
Date: Thu, 4 Jun 2009 22:10:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: smatch 1.53 released
Message-ID: <20090604201029.GG1065@one.firstfloor.org>
References: <alpine.DEB.2.00.0906021141010.19390@bicker> <87iqjedf2a.fsf@basil.nowhere.org> <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the description.

> So basically you grep for locking functions and you set the state
> based on that, then you grep for return statements and check that the

When you say "you" you mean smatch is doing that on its own
or does the user need to do that manually?

> Many of the locking false positives come from places where the unlock
> happens in a seperate function.  It should be relatively straight
> forward to make a list functions to say that if frob_the_module()
> returns -12, or -14 that implies it unlocked a certain lock.  I
> haven't done this yet.

How would one pass  that list of functions to smatch?

I understand correctly that right now it's not inter procedural in its
analysis?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

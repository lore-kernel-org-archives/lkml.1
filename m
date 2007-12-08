Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbXLHGdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbXLHGdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 01:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXLHGdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 01:33:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:41628 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbXLHGdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 01:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QeM6Zrd89amZ7E3GQFwzlrhIKUjbu9LzacKT9/w7gdxs1WmnK9D2LsRfN55qQkSlbzoKVspefLL84wdfW5NkL3UhpZIKt4cyC/Jtmln6le4YQtWrtnwflEbbH13Tl0MMbQvSgDAlvdCJQjEvrlcdpRQtgcpUhgOvbSnFHAFIxuE=
Message-ID: <46a038f90712072233v4ee1143cx68a82d15cfaa4402@mail.gmail.com>
Date: Sat, 8 Dec 2007 19:33:00 +1300
From: "Martin Langhoff" <martin.langhoff@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: git guidance
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jing Xue" <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
In-Reply-To: <200712010950.15628.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com>
	 <alpine.LFD.0.9999.0711290810170.8458@woody.linux-foundation.org>
	 <200712010950.15628.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2007 7:50 PM, Al Boldi <a1426z@gawab.com> wrote:
> Not sure what you mean by operationally transparent?  It would be transparent
> for the updating client,  and the rest of the git-users would need to wait
> for the commit from the updating client; which is ok, as this transparency
> is not meant to change the server-side git-update semantic.

I guess what he means is that when your write to the file -- from your
editor -- it can't be considered a commit. During an editing session
you might write a dozen times, only to commit it once you are happy
(that it compiles, passes tests, etc).

> Sure, you wouldn't want to change the git-engine update semantics, as that
> sits on the server and handles all users.  But what the git model is
> currently missing is a client manager.  Right now, this is being worked
> around by replicating the git tree on the client, which still doesn't
> provide the required transparency.

If you want a dumb-ish client CVS-style, you can try git-cvsserver.
But the git model is definitely superior -- "replicating the tree on
the client" is not a workaround but a central strategy.

Have you used git and other DSCMs much? From your writing, it sounds
like you may have misunderstood how some of the principles of git work
out in practice.

cheers,


m

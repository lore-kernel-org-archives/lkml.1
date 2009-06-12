Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZFLGsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZFLGsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZFLGsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:48:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33646 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZFLGsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gY5m6WR9xGNbejBn0/YB63AUnlAgqlqtIu7+ewn3a/6YeacmkHVtjIwPuFY9Obl2Nx
         r0tBII6viUQAMrjL7TIf9WsB96X0n18sStPwjghTQiYfpqYItgkCwS7fxlSsAic3niON
         x064H9c26l2DymK5BoAvGybV2K9sqyVEuUar0=
Date: Fri, 12 Jun 2009 08:48:20 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
Message-ID: <20090612064820.GB5209@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
	Steven Rostedt <srostedt@redhat.com>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:18:41AM -0700, Linus Torvalds wrote:
> The ide-tape.c changes also need some expert tender loving checks. I 
> neither know the code, nor have the hardware to check my fixups.

Yep, this is the result of the slimming exercise and diet pills we've
put ide-tape on because it'd grown obese over the years and it had its
own contraptions for buffer and pipeline handling which were clearly too
much. It had to be taught to behave just like every other ATAPI device
driver.

But seriously, I'm testing ide-atapi stuff regularly and I'll take a
look at the merge result during the weekend just to make sure everything
went fine.

> Almost 
> all the changes are actually by the same person - it's almost all Tejun's 
> code (and mostly the same patches), just coming in through two different 
> trees. Not very nice.

I think this was a one-time-thing only since it required syncing between
at least three trees so it is possible that somewhere along the way
things clash. It'll probably happen again when someone decides to change
block layer/LLDDs interface again but those are very seldom, I hope, for
the sake of everybody involved :).

-- 
Regards/Gruss,
    Boris.

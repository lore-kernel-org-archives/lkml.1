Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbYETABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbYETABn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbYETABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:01:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:42751 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbYETABd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vh5eLgXhwtR0yK+EKcaIKOXDNMmeA82GI81zgXx3NXbfUtHut/PNZ+xxU8fzsTcDLysMb5/5qSIF5aYkmo7Pyhytw8xQZdlAVyRchP8QhQzEHwJ4lXlfu7Wnd/M/G/Ywu0XIZPcwthmbpALVGUkKk6TmFcXddrew4Z3nrs8DBO0=
Message-ID: <9a8748490805191701h75e85bccw6e8aa4b452cde19c@mail.gmail.com>
Date: Tue, 20 May 2008 02:01:30 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805181513590.32253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
	 <20080517015705.GA20375@mit.edu>
	 <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
	 <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
	 <alpine.LFD.1.10.0805171715540.3020@woody.linux-foundation.org>
	 <9a8748490805181509r751cd152l3c9a765806da195d@mail.gmail.com>
	 <alpine.LFD.1.10.0805181513590.32253@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/19 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Mon, 19 May 2008, Jesper Juhl wrote:
>>
>> Ok, thanks a lot.  Now, I have one final question for you.
>> In order to be able to play around with the patches, see if they
>> apply, fix them up, test for merge conflicts etc etc, I obviously need
>> a tree with content, not just a bare tree. But I see on
>> master.kernel.org that all the published trees are bare trees.
>
> I think just about *everybody* does their own development on their own
> machine. I know I do, and I'm pretty certain that everybody else does too.
> Then we just upload the end result to master.kernel.org into a bare
> repository that is only used for exporting to others, never for anything
> else.
>
>> So, I assume I create a tree in my homedir like so;
>>   $ git clone -l -s /pub/scm/linux/kernel/git/torvalds/linux-2.6.git /home/juhl/trivial-work-tree
>> create all the branches and do all the work in that one,
>
> You can do that, and actually work on master.kernel.org, but do you really
> want to?
>
Not if I can help it, no. I just couldn't work out from the git docs
how to do it otherwise when working with kernel.org and bare trees.

<snip>
> Then, the easiest way to publish the result is to just create a bare
> repository on master.kernel.org, and push to it. And just make sure that
> you pre-populate that bare repo with my tree, so that when you push from
> your home machine, it only pushes the (smallish) actual changes!
>
> So the workflow I'd suggest is:
>
>  - do all the work on your own hardware
>
>  - create the initial (bare) kernel.org tree with
>
>        cd /pub/scm/linux/kernel/git/juhl
>        git clone --bare -l -s ../torvalds/linux-2.6 trivial-2.6
>
>  - then just push to that tree from your own machine
>
> and voila, you're all done.
>
<snip>

That worked beautifully. Thanks a lot.


Stephen: There is now a trivial-2.6.git tree at
git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial-2.6.git
with a 'next' branch that you can pull into linux-next, please.

  git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial-2.6.git next

Once we hit a merge window I'll rename the 'next' branch and ask Linus
to pull it, then create a new 'next'.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html

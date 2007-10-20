Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbXJTJkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbXJTJkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 05:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXJTJkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 05:40:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:2336 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbXJTJkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uq4oZUJRJ4pk/wWB0HhHHI3tAhHt8S390v8qqTfxnwCUpDYuJqWzBZqIOMsh0XBuIrQo4Z9h9jnKfXEqh3y/A8paSr/MUP+mVESWtgXx5frK0pWqYFUgyZkUcRa6H7QY4mEupdiPMy+DAQVd0kkHojBYfrIdmmFBwW5RH6OMVBM=
Message-ID: <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
Date: Sat, 20 Oct 2007 02:40:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: git/cscope with x86 merge
Cc: "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
	 <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 15 Oct 2007, Yinghai Lu wrote:
> >
> > after the merge:
> > 1. git
> > git log -p arch/x86/kernel/io_apic_64.c
> > only can show the log from the merge..., and can not get log before
> > merge for x86_64/kernel/io_apic.c
> > Any git update for that?
>
> Use
>
>         git log -p --follow arch/x86/kernel/io_apic_64.c
>
> where the "--follow" tells git to follow renames.
>
> And, of course, "git blame -C" will follow renames and copying of code
> across file boundaries too.
>
> NOTE! In both cases you may actually have to tell git to not limit its
> rename detection when it sees lots of files. You can do that
> once-and-for-all with
>
>         git config --global diff.renamelimit 0
>
> which should take care of it (although it seems that due to unlucky
> timing, the current stable git release does not honor the renamelimit for
> merging, so if you actually need to have git merge data across a rename,
> you should use the current "master" branch of git. Junio is sadly away
> for two weeks right now)

git log -p --follow arch/x86/kernel/vmlinux_64.lds.S

can not trace to arch/x86_64/kernel/vmlinux.lds.S

YH

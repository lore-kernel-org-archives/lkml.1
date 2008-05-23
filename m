Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYEWR0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYEWR0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYEWR0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:26:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYEWR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:26:35 -0400
Date: Fri, 23 May 2008 10:25:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Switch apm to unlocked_kernel
Message-Id: <20080523102537.2fbc74f3.akpm@linux-foundation.org>
In-Reply-To: <20080523232339.27a28b5b.sfr@canb.auug.org.au>
References: <20080522212204.177410b8@core>
	<20080523110353.7a1360b5.sfr@canb.auug.org.au>
	<20080523120617.6a4c115c@core>
	<20080523232339.27a28b5b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 23:23:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> On Fri, 23 May 2008 12:06:17 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > Andrew shouts at me if I send him patches that don't fix the style of
> > the lines around so you get some style changes even when I cut bits out
> > of diffs.

Don't think so.  Unrelated changes are well-known poor-form.

I do think that if one is already changing a line which is incorrectly
laid out then there's no point in _leaving_ it incorrect.  There's no
downside to fixing it.

That being said, it's often sorely tempting to go hunting down nearby
sillinesses.  I succumb to that temptation and usually won't complain
when others do also, up to a point.

> I think that approach is *stupid* too and style should be done
> > after for the entire file.
> 
> Then let the maintainer (nominally me) shout at Andrew.  I don't agree
> with those style changes and we usually leave such purely stylistic
> things to the maintainer of the file in question.

mm, not really.  Wrong is wrong and if nominal maintainer insists on
retaining wrong we have cheery bunfights about it.

> If Andrew requires
> these changes, then Andrew is wrong about this.  It just confuses the
> real changes and adds to the overheads of those trying to do reviews (of
> which we have too few).

I think those changes went above and beyond the call.

> And in this case "fix" is in the eye of the
> beholder.

And that is why we have a standard - so that different parts of the
kernel do not end up having different appearance due to local
preferences.


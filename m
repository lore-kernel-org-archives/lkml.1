Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbYHEQNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbYHEQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYHEQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:12:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218AbYHEQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:12:52 -0400
Date: Tue, 5 Aug 2008 09:12:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alois.klingler@chello.at
Cc: Ondrej Zajicek <santiago@crfreenet.org>, MadLoisae@gmx.net,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: kernel oops with framebuffer device vt8623fb
Message-Id: <20080805091229.a613d423.akpm@linux-foundation.org>
In-Reply-To: <489836D3.2050008@chello.at>
References: <487E2911.5090701@gmx.net>
	<20080717013917.GA1695@localhost.localdomain>
	<20080728204817.ebaa621b.akpm@linux-foundation.org>
	<489836D3.2050008@chello.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 13:17:39 +0200 "alois.klingler@chello.at" <alois.klingler@chello.at> wrote:

> 
> Andrew Morton wrote:
> > On Thu, 17 Jul 2008 03:39:18 +0200 Ondrej Zajicek <santiago@crfreenet.org> wrote:
> >
> >   
> >> On Wed, Jul 16, 2008 at 07:00:02PM +0200, MadLoisae@gmx.net wrote:
> >>     
> >>> Hi!
> >>>
> >>> I've updated my machine from 2.6.25.11 to 2.6.26 and I think I've found 
> >>> a problem.
> >>>
> >>> If I load the module vt8623fb i get a kernel oops, if the VIA 8623 
> >>> display framebuffer driver is compiled direct into kernel the system 
> >>> hangs up very early at booting the kernel.
> >>>       
> >> I am sorry for mistake, here is a patch for 2.6.26 fixing the bug:
> >>
> >> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
> >>     
> >
> > I went back through the email thread and wrote your changelog for you. 
> > Not a very good one though.
> >
> > It would be better were you to write your changelogs, please.
> >
>
> Hi!
> 
> This issue is still not fixed in 2.6.26.1 - may be there a way to commit 
> it in 2.6.26.2?
> 
> Still, the provided patch I got on 07/17/2008 works great ...
> 
> Thanks, anyway!
> 
> kind regards, Alois
> 

(top-posting repaired)

The fix will be in my next batch for Linus.  It'll be merged this week.

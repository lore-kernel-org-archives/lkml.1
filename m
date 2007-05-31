Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXEaPv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXEaPv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXEaPvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:51:21 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbXEaPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:51:20 -0400
Date: Thu, 31 May 2007 08:51:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
Message-Id: <20070531085114.420b9cbe.akpm@linux-foundation.org>
In-Reply-To: <465EAF90.3030803@drzeus.cx>
References: <4655834F.3050301@drzeus.cx>
	<20070524170654.5d674474.akpm@linux-foundation.org>
	<4656602A.3010000@drzeus.cx>
	<20070524211737.daa3c99c.akpm@linux-foundation.org>
	<465666AE.5020600@drzeus.cx>
	<465EAF90.3030803@drzeus.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 13:20:48 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>

(top-posting reversed)

> Pierre Ossman wrote:
> > Andrew Morton wrote:
> >> Whatever.  I think you can work it out ;)   
> >>
> >>   
> > 
> > Bare with me, I just woke up ;)
> > 
> >> while (driver_probe_done() || (ROOT_DEV = name_to_dev_t(...)) == 0)
> >>
> >> perhaps?
> >>
> >> The loop-which-sleeps within a loop-which-sleeps seems poorly thought out?
> >>   
> > 
> > I'd say a matter of taste. I'm not a big fan och cramming things into
> > the while() clause.
> > 
> > The idea with the double loops was to keep this thread asleep when we
> > could detect meaningful work elsewhere in the kernel. You could just
> > remove the inner-most loop if it offends you. :)
> > 
>
> What was the verdict here? Were you satisfied with this or do you need a change?


I was kinda hoing to see version #2 with that funny loop cleaned up a bit?



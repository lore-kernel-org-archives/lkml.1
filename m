Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbYB2Wj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbYB2Wj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYB2WjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:39:21 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbYB2WjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:39:20 -0500
Date: Fri, 29 Feb 2008 14:38:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rostedt@goodmis.org
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
Message-Id: <20080229143856.64aec39b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802292315480.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	<1201659263.6766.40.camel@localhost>
	<Pine.LNX.4.64.0801310251090.17507@scrub.home>
	<1201745776.6195.14.camel@localhost.localdomain>
	<Pine.LNX.4.64.0801310404480.17507@scrub.home>
	<1201914175.6216.46.camel@jstultz-laptop>
	<Pine.LNX.4.64.0802081718040.3378@scrub.home>
	<1202523452.6174.45.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802101917030.3378@scrub.home>
	<1202774999.5984.106.camel@localhost>
	<Pine.LNX.4.64.0802120335170.3378@scrub.home>
	<1202963796.6195.141.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802150436300.1822@scrub.home>
	<1203382940.5984.242.camel@localhost>
	<Pine.LNX.4.64.0802190219360.2723@scrub.home>
	<1203472250.6123.98.camel@localhost>
	<Pine.LNX.4.64.0802200348230.2723@scrub.home>
	<1203647951.6150.80.camel@localhost.localdomain>
	<Pine.LNX.4.64.0802290547320.2723@scrub.home>
	<20080229140842.575e72aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802292315480.2723@scrub.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 23:27:01 +0100 (CET)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Fri, 29 Feb 2008, Andrew Morton wrote:
> 
> > The changelog provides no reason for the revert of those two patches.
> > 
> > Look at it from the point of view of a person who hasn't been following the
> > discussion (whose initials might be LT).  That person might get puzzled and
> > upset, no?
> 
> I'm puzzled at how to explain this...

Please try.

> The whole details have been explained over and over during the discussion.

That's no use to someone who is trying to understand this patch.

> The simple answer is that CLOCK_TICK_ADJUST has been causing extra clock 
> drift, John's attempt didn't fix the real cause.
> My patch doesn't just revert the patches, it also includes the _real_ fix, 
> so why would the real fix require more justification? That person also 
> didn't get puzzled why two patches claiming to fix the same problem got 
> merged...

A revert patch's changelog should explain why the code is being reverted. 
ie: what was wrong with it.

A bugfix patch's changelog should explain the problem which is being
solved, and how it solves it.


Look at it from the point of view of someone who isn't intimately involved
in that subsystem and who isn't following every email on whatever mailing
list.  Your changelog des not provide sufficient detail for such a person
to understand your patch.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbZCYRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbZCYRR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZCYRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:17:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZCYRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:17:48 -0400
Date: Wed, 25 Mar 2009 13:17:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Credit for vsprintk work
In-Reply-To: <alpine.LFD.2.00.0903250944360.3032@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0903251311380.5675@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com> <alpine.LFD.2.00.0903250944360.3032@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Linus Torvalds wrote:

> 
> 
> On Wed, 25 Mar 2009, Steven Rostedt wrote:
> > 
> >  $ git blame lib/vsprintf.c |grep 'Frederic Weisbecker' | wc -l
> > 542
> > 
> > You did a hell of a lot of work on vsprintf.c, and you are still too 
> > modest to put in a copyright at the top.
> 
> I don't disagree, but "git blame" is _not_ a good way to do this.
> 
> At a minimum, use "git blame -w -M" to ignore stuff that was just moved 
> and re-indented. but even then, quite frankly, "git blame" doesn't really 
> make much sense. If you have
> 
> 	if (!(flags & LEFT)) {
> 		while (len < field_width--) {
> 
> that turns into
> 
> 	if (!(spec.flags & LEFT)) {
> 		while (len < spec.field_width--) {
> 
> then blame will count the new lines to the person who did the change, but 
> was that really a code change? It was a small re-org.
> 
> I picked that example because those particular lines actually go back to 
> before even the bitkeeper days - their original author is lost in history. 
> It used to look different (field_width was called 'size' back in the 
> days), but the logic of the code may well go back to the original code by 
> Lasu in 1991.
> 
> The only point here? Don't use "git blame" as a copyright assigner.

I totally agree. I only used the git blame as a prelude to my argument. In 
fact, your explanation here verifies my point even more. That is, some 
people do not like the change log type notifications at the top of files.
You even point out that the original author was lost in history.

I agree that trivial changes to files or even simple bug fixes do not 
qualify a name at the top of the file. But any time there is a design 
change, that should be credited. git blame was not my reason I posted this 
email. I was Cc'd on all those emails that went back and forth for this 
improvement. As I was showing students the work that was done, I noticed 
that there was no copyright statement for it.

But I understand what you are saying. I should have been clearer in my 
intent, otherwise you'll get a bunch of people crying for copyrights just 
because they fixed all the whitespace in a file ;-)

-- Steve


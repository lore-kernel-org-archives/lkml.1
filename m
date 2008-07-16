Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYGPU37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYGPU37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYGPU3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:29:49 -0400
Received: from roath.org ([87.106.182.47]:38319 "EHLO mail.roath.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758287AbYGPU3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:29:47 -0400
Date: Wed, 16 Jul 2008 22:29:41 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: The state of linux security
Message-ID: <20080716202941.GA2793@master.roath.intern>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: sroas@roath.org (Stefan Roas)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jul 16, 2008 at 16:05:07, Cheradenine Zakalwe wrote:
> Right, for a start, if I was a professor at university I'd much rather
> some "smart" students crashed 100 boxes a day for a year than one
> owned several servers.  In any case, it seems absurd that anybody
> looking for security holes to either subvert or crash systems would be
> deterred by the lack of security commit messages.  They already know
> what they are looking for.  On the other hand, there has to be some
> metrics available for normal people to make an informed decision about
> the relative security of linux and the likely hood that smart people
> are able to cause a bit of mindless vandalism or get up to much worse.

I don't know what to make of this paragraph. I'm currently employed at a
University and there are quite a few linux boxes (even available to
students, some of them probably "smart") and I don't have any issues with
crashes or servers getting owned. The only upgrade decsision I have on
these servers is when to reboot after the vendor supplies patched kernels.

> Your hand waving and obfuscation simply do not wash.  The bugs being
> talked about are not just any bugs.  They have their own commercial
> value because they can allow the complete subversion of your systems.
> This (for most people I'd guess) is far more dangerous than simply
> having their computers crash.  Also, I'd bet that many security bugs
> aren't triggerable under any normal workload.  If my machines have
> been running for 2 months why bother bringing them down in order to
> bugfix something that doesn't seem to affect them anyway?

Because uptime isn't everything. Bugs can (and will) happen in any complex
system. Furthermore not every bug obviously has a security implication. If
you discover one, just reply to the release announcement and tell the rest
of the world of your discovery.

> This business of passing the buck onto vendors is also absurd.  If
> security is not built into your development mindset and models from
> the start you are being utterly naive and complacent.  I commend the
> stable team for fixing and backporting what they can, but I need to
> know what I've been exposed to and for how long.  From the looks of
> what the paxteam has been saying, it seems linux security is pretty
> bad and has been getting worse.  This must be in no small part to you
> putting your head in the sand, sticking your fingers in your ears and
> going "lalalalala".

Why is it absurd that the vendors take care of the bugs in their specific
kernels. Most vendors deliver kernels with additional patches anyway, so
it's their duty to fix the bugs. I've never experienced this
"finger-in-the-ears" attitude here. And I don't think security isn't
important here. But the system is very complex and security issues in a
bug aren't easy to spot. I've been running linux since 1996 and every
successful attack I've seen on any of my systems so far was either caused
by weak passwords or badly written php webapps (I haven't been root-owned
so far, an I hope it stays that way).

> Obfuscating the risk people are exposed to means you have no real
> accountability and thus no incentive to not put so many security bugs
> there in the first place.  If other developers or users don't know how
> bad things are how can they make informed decisions about development
> processes or where they can afford to deploy linux?

There is nobody here deliberatly obfuscating bugs. It's just not always
plain to see that there is a security issue.

> If it turns out that the current development model has produced too
> many security problems then the development model must change. I'd
> like to think that the integrity of most peoples systems is more
> important than some micro benchmark improvement because of some
> complex scheduler change.  That's not to say the latter isn't
> important, just that more time and effort needs to be put into making
> sure that the changes don't affect users in potentially disasterous
> ways.

If you want more stability stay with your vendor kernel. On my personal
system I always run the latest stable release. That's my personal decision
and the response times of the stable team are almost unbeatable. I sure
won't win any uptime contest that way, but there isn't something in the
world I'm less interested in. I can easily live with the 1-2 minutes
downtime once in a while.

> One more thing I'd like to throw out there on the issue of
> accountability is this:  How do I know that some developers have not
> been paid to specifically introduce some obscure security flaw?  Given
> that such subversions happen frequently in every other field of human
> endeavour where potential profit is involved, this is not beyond the
> realms of possibility.  The more linux is adopted the more likely this
> is to become a real issue.  For that reason it is imperitive that
> these potentially severe flaws are dealt with openly and transparantly
> when discovered.

Have you ever seen what happens with patches on this list? There's almost
never a patch among them that slips through not reviewed or commented by
anyone. I seriously doubt anybody would be willing to spend money to slip
an exploitable hole into the kernel. The risk of getting detected early is
way to high. And any developer involved in such a plot is probalby out of
business forever. He will never again contribute to any open source
project and he most likely won't ever find an employer again. Would you
hire someone that has a record of backdooring software for money?

> If the attitudes of the people at the top of linux development don't
> change this is the end of the linux experiment for me and i'm sure
> many other people.  The percieved benifits of transparancy, openness
> and cost will have been completely smashed for the vast majority of
> users.  This is not something to be taken lightly.

I don't think the attitude of the top developers is an issue here. Maybe
you are overreacting to some extent. Calm down and think about the
questions you raised. If you want the quality of the code raised, review
patches, test rc-kernels or mm-kernels. Raise concerns about changes
early. Or just tell this list about possible security implications of
fixes in -stable by replying to the announcements. There's plenty of
possibilities to contribute and hence increase the quality.

Best regards,
  Stefan Roas

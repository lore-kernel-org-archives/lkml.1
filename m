Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYAAWga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYAAWga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 17:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYAAWgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 17:36:21 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:33795 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754641AbYAAWgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 17:36:20 -0500
Message-ID: <477AC060.5040004@nigel.suspend2.net>
Date: Wed, 02 Jan 2008 09:36:16 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: suspend2-devel@lists.tuxonice.net,
       "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: What's in store for 2008 for TuxOnIce?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

With the start of a new year, I suppose it's a good time to think about
what I'd like to do with TuxOnIce this year and see what feedback I get.

First up, I'm thinking about closing the mailing lists and asking people
to use LKML instead for reporting issues and so on. I'm thinking about
this because it will help with allowing people who work on mainline to
see how stable (or otherwise!) TuxOnIce is now. It should also help when
(as often happens) bug reports aren't actually issues with the patch,
but with vanilla (ie drivers). Perhaps it will also help with whatever
effort I find time to make towards convincing Andrew that it really does
have significant advantages over [u]swsusp and kexec based hibernation.

Secondly, I'm planning on moving the website soonish. It's taken longer
than I planned because it will be sharing with another server I'm
maintaining, and it has taken longer than expected to find good hosting
for the other server (which was done first). Now that I'm happy with the
other server's state, I'm hoping to start shifting
suspend2.net/tuxonice.net soon.

For those who might be looking for hosting themselves, I'm using
slicehost. I initially tried GoDaddy, but had terrible service, problems
with draconian limits on the volume of outgoing email (1000/day by
default - useless if you're doing mailing lists) and unexpected,
unexplained delays in mail delivery through the SMTP delay they force
you to use. Slicehost, on the other hand, are terrific to deal with in
everyway. If you sign up with them because of this email, please
consider putting my email (nigel at suspend2.net) as the referrer - I
then get a discount on the cost of the hosting.

Third, regarding the patch itself, I'm taking my time in working towards
the 3.0 release. We don't have any major bugs with 3.0-rc3 reported, but
I have some things I want to complete before the final release:
* see it well tested;
* get a finished initial version of the cluster support;
* finish completing support for the new resume-from-other kernels
functionality that Rafael has added in 2.6.24. (We can resume from the
same kernel at the moment, but I need to convince myself that nosave
data is properly handled).

Regards,

Nigel

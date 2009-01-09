Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZAIJ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZAIJ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZAIJ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:28:59 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33585 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbZAIJ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:28:54 -0500
Message-ID: <55312.166.70.238.44.1231490626.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20090109090956.GA28484@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
    <20090109064658.GG5038@1wt.eu>
    <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
    <20090109084540.GH5038@1wt.eu>
    <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>
    <20090109090956.GA28484@1wt.eu>
Date: Fri, 9 Jan 2009 01:43:46 -0700 (MST)
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
From: jmerkey@wolfmountaingroup.com
To: "Willy Tarreau" <w@1wt.eu>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... snip

>> From my experience with dealing with these systems, and observation of
>> how
>> RBL databases work, when an infected system gets blacklisted, it stays
>> that way until the user goes to the websites and requests removal.  I
>> have
>> found these zombie systems tend to stay that way, and no, by default you
>> NEVER want to unblock them for at least 6 months.
>
> This is stupid considering that most of them change their IP address every
> 24 hours, or at most every 7 days. This is just used to show that spam
> rate
> drops, hiding the fact that valid mails drop for similar reasons. For your
> own use, you might consider that you'll never receive mails from people
> hosted at the same ISP as the bots you block, but doing this on a large
> scale or for companies who do their business around e-mail is plain
> stupid.
>
> I'm on a static IP, but a lot of people I know are not. It would be
> unfair to block them from posting to, say, LKML just because the week
> before, someone with their address had been sending spam. And no, it
> does not help getting the problem solved since the only users annoyed
> are not the ones with the faulty installation.
>
> Willy
>
>

Allowing a server on a dynamic IP range to act as a mail server is what is
stupid.  Most email blockers also block dynamic IP ranges since these
systems are typically the ones most commonly infected, and the RBL
databases.  They just use a different technique, they base it on DNS maps
of internet address ranges, and not behavior.  It will only block the smtp
port for these systems -- and mail servers originating from dynamic ranges
should be blocked anyway -- and are by most commercial email gateway
boxes.

Jeff



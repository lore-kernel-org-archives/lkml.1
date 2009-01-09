Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZAIS7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZAIS7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZAIS7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:59:13 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36021 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZAIS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:59:12 -0500
Message-ID: <37451.166.70.238.44.1231524844.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <49672D75.4060201@davidnewall.com>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
       <20090109064658.GG5038@1wt.eu>   
    <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
       <20090109084540.GH5038@1wt.eu>   
    <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>
       <20090109090956.GA28484@1wt.eu>
    <55312.166.70.238.44.1231490626.squirrel@webmail.wolfmountaingroup.com>
    <49672D75.4060201@davidnewall.com>
Date: Fri, 9 Jan 2009 11:14:04 -0700 (MST)
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
From: jmerkey@wolfmountaingroup.com
To: "David Newall" <davidn@davidnewall.com>
Cc: jmerkey@wolfmountaingroup.com, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote:
>> Allowing a server on a dynamic IP range to act as a mail server is what
>> is
>> stupid.
>
> Sorry to be argue semantics, but I think it's SMTP clients that are the
> major cause of spam.  Many, probably most, ISPs provide an SMTP relay
> for their subscribers, and blocking these dynamic addresses doesn't
> present a hard impediment for delivery of their mail to you.  None the
> less, to say that people on a dynamic IP address should be *obliged* to
> go through a relay is offensive.  (Not that you did say that, but I
> think it's what you had in mind.)
>

That's good point, but not what I see in actual practice.  These zombie
systems don't seem to use the smtp gateway for their ranges, they send the
emails direct.  From my observations, most of these systems tend to stay
zombies, since almost all of them are windows systems.

I have discovered that by using this method to block them, once they open
a connection and I start dropping traffic while the connection is left
open it "tarpits" the bots and causes a cascade failure in the botnet
network for about 20 minutes until the systems start skipping the mail
server doing the bocking.

Jeff


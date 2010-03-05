Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0CESCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:02:31 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:43339 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753581Ab0CESCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:02:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BfwDYGApTWdv8kXuHGoaKxc1MdAm3nwIKQQ9us+jyBcFwURm/Qt8dJEfoboPwNtYOxHfj7JByxWl5ggZxut2L5x3eFrqZL1+o0UFXOJrzjVayC8TJhBeeBwb4NvYApf+;
Date: Fri, 5 Mar 2010 10:02:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Cc: xavier.bestel@free.fr, skeggsb@gmail.com, airlied@linux.ie,
       crmafra2@gmail.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, daniel@fooishbar.org, dri-devel@lists.sf.net,
       mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: Making Xorg easier to test
Message-ID: <20100305100244.0d118451@jbarnes-piketon>
In-Reply-To: <20100305.095406.115464327.davem@davemloft.net>
References: <20100305154143.GD2505@tempa>
	<20100305.074932.225568964.davem@davemloft.net>
	<1267811424.3405.110.camel@skunk>
	<20100305.095406.115464327.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Mar 2010 09:54:06 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Xavier Bestel <xavier.bestel@free.fr>
> Date: Fri, 05 Mar 2010 18:50:24 +0100
> 
> > On Fri, 2010-03-05 at 07:49 -0800, David Miller wrote:
> >> From: Daniel Stone <daniel@fooishbar.org>
> >> Date: Fri, 5 Mar 2010 17:41:43 +0200
> >> 
> >> > I understand that you guys are upset about this, so maybe you'd like to
> >> > donate, say, 10% of your developer base to help out? That'd be pretty
> >> > ace.
> >> 
> >> You have to support less than %10 of the amount of hardware we have to
> >> support.
> > 
> > You can't compare a network card and a GPU. The latter is way more
> > complex to code for.
> 
> I wasn't talking specifically about network cards.  But if you want
> specific examples...
> 
> How about the x86 or parisc cpu, and all their derivatives, are those
> complex enough for you? :-)
> 
> I've worked on OpenGL capable grapics card drivers of various
> vintages, and I honestly don't think there is anything in there more
> complex than what we have to deal with in the kernel.

I think you must be saying this for the sake of argument.  The
complexity lies not in the programming interfaces exposed by the device
(those indeed are complex, more so than some CPUs, less so than
others).  The complexity lies in the fact that those interfaces change
from revision to revision, and even between boards sharing the same
chip.  And more than that, the interfaces exposed to applications are
spread across many software components, some of which send commands to
the hardware directly.  The problem Linus ran into is directly related
to this fact, because it involved the interfaces between a few of these
components.

So from that perspective, the graphics stack is the most complex one in
Linux by a long shot.  It's even worse than if we had STREAMS
networking with a ton of different modules up in userspace messing with
protocol. :)

-- 
Jesse Barnes, Intel Open Source Technology Center

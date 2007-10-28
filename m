Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXJ1WIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXJ1WIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXJ1WI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:08:29 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:40055 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949AbXJ1WI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:08:28 -0400
Message-ID: <47250878.6040506@crispincowan.com>
Date: Sun, 28 Oct 2007 15:08:56 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ray Lee <ray-lk@madrabbit.org>, Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <20071024223124.GI30533@stusta.de>	<446110.89443.qm@web36608.mail.mud.yahoo.com>	<20071025002356.GB3660@sequoia.sous-sol.org>	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com> <20071025024131.6082e4a8@the-village.bc.nu>
In-Reply-To: <20071025024131.6082e4a8@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The idea that poor security is worse than no security is fallacious,
>> and not backed up by common experience.
>>     
> There is a ton of evidence both in computing and outside of it which
> shows that poor security can be very much worse than no security at all.
> In particular stuff which makes users think they are secure but is
> worthless is very dangerous indeed.
>
> When you know that security is limited you act appropriately, when you
> believe security is good but it is not you take inappropriate risks and
> get badly burned.
>   
The "bad security is worse than no security" idea comes exactly from
what Alan says above: it happens when the security is not as good as you
think it is, and so you don't take adequate precautions.

Using the ongoing bicycle lock example, the discovery a few years ago
that a certain model of Kryptonite bike lock could be picked with a
simple pen made the security on this otherwise very sturdy lock become
abruptly very weak http://www.wired.com/culture/lifestyle/news/2004/09/64987

Conversely, the case can also be made that "weak security is better than
no security". It is better to secure your bike with a $10 lock than no
lock. If someone insists on only "high" security bike locks that cost
$1000 and weigh 30 lbs, then most people will choose to not lock their
bikes, or skip biking all together.

IMHO, much of the criticism leveled at proposed LSMs has been of the
latter kind, or worse. That the security of the proposed LSM does not
meet some particular use case does not make it "bad", it makes it not
for that use case.

To reject an LSM for providing "bad" security, IMHO you should have to
show how it is possible to subvert the self-stated goals of that LSM.
Complaints that the LSM fails to meet some goal outside of its stated
purpose is irrelevant. Conjecture that it probably can be violated
because of $contrivance is just so much FUD.

Exception: it is valid to say that the self-stated goal is too narrow to
be useful. But IMHO that bar of "too narrow" should be very, very low.
Defenses against specific modes of attack would be a fine thing to build
up in the library of LSMs, especially if we got a decent stacking module
so that they could be composed.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work


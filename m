Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbXJZQdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbXJZQdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXJZQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:32:57 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:59619 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXJZQc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:32:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=Ulc/2JrIM1TT9nkp6XUBjQmjtjJ+zjY0D6224HR5tyNBxuf2H0T0h2K+bYafHbjDbsdgJppvFYKcDxgUJudweVatc7lo9lOOHpfLnplKMf8ie9/ykdNIgfrGATyWaw7Q;
Message-ID: <472216A5.8070908@simon.arlott.org.uk>
Date: Fri, 26 Oct 2007 17:32:37 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Tilman Schmidt <tilman@imap.cc>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to	static
 interface)
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026155833.GF23016@kroah.com>
In-Reply-To: <20071026155833.GF23016@kroah.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/07 16:58, Greg KH wrote:
> On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
>> On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
>> > I'm trying to compile a list of all known external modules and drivers
>> > and work to get them included in the main kernel tree to help prevent
>> > these kinds of things.  If you know of any that are not on the list at:
>> > 	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>> > please feel free to add them, or email me with the needed information
>> > and I will add them to the list.
>> 
>> That's certainly helpful, but I still think there will always be
>> a number of external modules that cannot be merged right now or at
>> all, and deliberately making life difficult for out-of-tree code
>> maintainers in order to coerce them into submitting their code for
>> inclusion in the kernel will not work, it'll only create bad
>> feelings.
> 
> Do you have examples of proof of this?  Read
> Documentation/stable_api_nonsense.txt for how we already make
> out-of-tree code developer's lives hell :)

The change makes it much harder to develop in tree too. Also, this really 
needs to be reverted and put in the feature removal schedule... unless 
you intend to deliberately make all out of tree LSMs unusable with no 
warning and no time to have them added to the kernel? We're already at 
2.6.24-rc1.

-- 
Simon Arlott

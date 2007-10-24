Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbXJXUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbXJXUrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXJXUrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:47:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50615 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbXJXUrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:47:01 -0400
Date: Wed, 24 Oct 2007 22:46:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Crispin Cowan <crispin@crispincowan.com>
cc: Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <471FA8A1.6070904@crispincowan.com>
Message-ID: <Pine.LNX.4.64.0710242232260.17781@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
 <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org>
 <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org>
 <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de>
 <471F8AC5.9080300@simon.arlott.org.uk> <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
 <471FA8A1.6070904@crispincowan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24 2007 13:18, Crispin Cowan wrote:
>Jan Engelhardt wrote:
>> On Oct 24 2007 19:11, Simon Arlott wrote:
>>   
>>> * (I've got a list of access rules which are scanned in order until one of 
>>> them matches, and an array of one bit for every port for per-port default 
>>> allow/deny - although the latter could be removed.
>>> http://svn.lp0.eu/simon/portac/trunk/)
>>>     
>> Besides the 'feature' of inhibiting port binding,
>> is not this task of blocking connections something for a firewall?
>>   
>So now you are criticizing his module. Arguing about the merits of
>security semantics. This is exactly why Linus wanted LSM, so we don't
>have to have these kinds of discussions, at least not on LKML :)

This was a question. I was perfectly aware that iptables alone
does not prohibit binding, and there are reasons to inhibit binding.

But sometimes, a coder does not know where to start - chances are,
that someone else wanting to do bind(2) inhibiting is doing it
with a syscall table change. Or coder did not notice that a firewall
is sufficient for the task to be achieved (which is not always the
case - hence the question).

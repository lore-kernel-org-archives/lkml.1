Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXJXUSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXJXUSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXJXUS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:18:27 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:43224 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754251AbXJXUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:18:26 -0400
Message-ID: <471FA8A1.6070904@crispincowan.com>
Date: Wed, 24 Oct 2007 13:18:41 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
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
References: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 24 2007 19:11, Simon Arlott wrote:
>   
>> * (I've got a list of access rules which are scanned in order until one of 
>> them matches, and an array of one bit for every port for per-port default 
>> allow/deny - although the latter could be removed.
>> http://svn.lp0.eu/simon/portac/trunk/)
>>     
> Besides the 'feature' of inhibiting port binding,
> is not this task of blocking connections something for a firewall?
>   
So now you are criticizing his module. Arguing about the merits of
security semantics. This is exactly why Linus wanted LSM, so we don't
have to have these kinds of discussions, at least not on LKML :)

It seems to me that LSM used to be an open API. Anyone could code to it,
so you could at least try to ship a module that will load into a major
vendor's stock kernel for an important release.

Now with this change, it is effectively a closed API. You can only load
the modules that the distro vendor shipped to you. If you want
*anything* other than what RH or Novell or Canonical or Mandriva etc.
says you should want, then you have to hack the source code for your kernel.

Open source is great, and it is wonderful that you *can* hack the source
if you need to, but demanding that end users patch their source code
when all they want to do is load a module is really, really sad.

Please revert this patch. Its benefits are no where near its costs.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work


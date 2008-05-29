Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYE2MUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYE2MUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYE2MUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:20:25 -0400
Received: from mail.vapor.com ([85.114.133.49]:42774 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYE2MUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:20:24 -0400
Date: Thu, 29 May 2008 14:20:16 +0200
From: pomac@vapor.com
To: YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [ipv6] Odd behaviour...
Message-ID: <20080529122016.GG11812@pomac.netswarm.net>
References: <20080529084157.GD11812@pomac.netswarm.net> <20080529.182853.67833046.yoshfuji@linux-ipv6.org> <20080529100822.GF11812@pomac.netswarm.net> <20080529.194616.51574992.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080529.194616.51574992.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:46:16PM +0900, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <20080529100822.GF11812@pomac.netswarm.net> (at Thu, 29 May 2008 12:08:22 +0200), pomac@vapor.com says:
> 
> > On Thu, May 29, 2008 at 06:28:53PM +0900, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> > > In article <20080529084157.GD11812@pomac.netswarm.net> (at Thu, 29 May 2008 10:41:57 +0200), pomac@vapor.com says:
> > > 
> > > > On Thu, May 29, 2008 at 12:27:29AM -0700, Andrew Morton wrote:
> > > > > On Tue, 27 May 2008 00:58:30 +0200 Ian Kumlien <pomac@vapor.com> wrote:
> > > > > 
> > > > > > Hi, 
> > > > > > 
> > > > > > I just recently acquired a new ipv6 tunnel since my two previous brokers
> > > > > > has gone out of business. I now use hurricane electrics tunnel since i
> > > > > > have really good ping times to it's node in Amsterdam.
> > > > > > 
> > > > > > Anyways, i have setup a local network tunnel and enabled forwarding.
> > > > > > 
> > > > > > After about 300 seconds, it all stops working. I have to disable and
> > > > > > re-enable it on the firewall/router to get it working again.
> > > > > > 
> > > > > > tcpdump shows the router/firewall doing odd things like:
> > > > > > (i renamed my host to piv6)
> > > > > > 
> > > > > > 00:48:14.294173 IP6 piv6 > igloo.stacken.kth.se: ICMP6, echo request,
> > > > > > seq 321, length 64
> > > > > > 
> > > > > > 00:48:14.341288 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
> > > > > > 321, length 64
> > > > > > 
> > > > > > 00:48:14.341317 IP6 fe80::55e4:1b90 > igloo.stacken.kth.se: ICMP6,
> > > > > > redirect, piv6 to piv6, length 160
> > > > > > 
> > > > > > 00:48:14.341332 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
> > > > > > 321, length 64
> > > > > > ---
> > > > > > 
> > > > > > fe80::55e4::1b90 is the local ip of the ipv6 tunnel.
> > > > > > (note: the packet never arrives at it's destination)
> > > > > > 
> > > > > > Any ideas of what could be going wrong?			
> > > > > 
> > > > > (cc netdev - afaik linux-net is kind of dead)
> > > > 
> > > > Thanks, i knew i missed something, -net was the one that was already in
> > > > my email client so... =)
> > > > 
> > > > > What kernel version are you running?
> > > > 
> > > > The router/fw is running 2.6.25.1, the client is running 2.6.25.4
> > > > 
> > > > Any additional information i should provide?
> > > 
> > > How do you assign the address?
> > 
> > On the router/fw there is a sit tunnel thats started with 'ip'.
> > 
> > The clients get their addresses by radvd which only uses a local
> > interface on the router/fw...
> 
> Please draw w a network topology figure.

It's very basic... 

client -> router/fw -tap-tunnel-> -hurricane-electric-> internet.

(the firewall/router is my normal ipv4 firewall but for ipv6 it acts as
a router, thus the "router/fw" or "firewall/router".

but, router/fw -tap-tunnel-> -hurricane->electric-> internet. always
works, and outgoing communications always works. This is only a problem
for incoming communications.

> --yoshfuji

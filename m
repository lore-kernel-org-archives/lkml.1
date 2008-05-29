Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYE2KIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYE2KIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYE2KI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:08:28 -0400
Received: from mail.vapor.com ([85.114.133.49]:53444 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYE2KI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:08:27 -0400
Date: Thu, 29 May 2008 12:08:22 +0200
From: pomac@vapor.com
To: YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [ipv6] Odd behaviour...
Message-ID: <20080529100822.GF11812@pomac.netswarm.net>
References: <1211842711.8367.11.camel@localhost> <20080529002729.d87fed29.akpm@linux-foundation.org> <20080529084157.GD11812@pomac.netswarm.net> <20080529.182853.67833046.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080529.182853.67833046.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 06:28:53PM +0900, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <20080529084157.GD11812@pomac.netswarm.net> (at Thu, 29 May 2008 10:41:57 +0200), pomac@vapor.com says:
> 
> > On Thu, May 29, 2008 at 12:27:29AM -0700, Andrew Morton wrote:
> > > On Tue, 27 May 2008 00:58:30 +0200 Ian Kumlien <pomac@vapor.com> wrote:
> > > 
> > > > Hi, 
> > > > 
> > > > I just recently acquired a new ipv6 tunnel since my two previous brokers
> > > > has gone out of business. I now use hurricane electrics tunnel since i
> > > > have really good ping times to it's node in Amsterdam.
> > > > 
> > > > Anyways, i have setup a local network tunnel and enabled forwarding.
> > > > 
> > > > After about 300 seconds, it all stops working. I have to disable and
> > > > re-enable it on the firewall/router to get it working again.
> > > > 
> > > > tcpdump shows the router/firewall doing odd things like:
> > > > (i renamed my host to piv6)
> > > > 
> > > > 00:48:14.294173 IP6 piv6 > igloo.stacken.kth.se: ICMP6, echo request,
> > > > seq 321, length 64
> > > > 
> > > > 00:48:14.341288 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
> > > > 321, length 64
> > > > 
> > > > 00:48:14.341317 IP6 fe80::55e4:1b90 > igloo.stacken.kth.se: ICMP6,
> > > > redirect, piv6 to piv6, length 160
> > > > 
> > > > 00:48:14.341332 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
> > > > 321, length 64
> > > > ---
> > > > 
> > > > fe80::55e4::1b90 is the local ip of the ipv6 tunnel.
> > > > (note: the packet never arrives at it's destination)
> > > > 
> > > > Any ideas of what could be going wrong?			
> > > 
> > > (cc netdev - afaik linux-net is kind of dead)
> > 
> > Thanks, i knew i missed something, -net was the one that was already in
> > my email client so... =)
> > 
> > > What kernel version are you running?
> > 
> > The router/fw is running 2.6.25.1, the client is running 2.6.25.4
> > 
> > Any additional information i should provide?
> 
> How do you assign the address?

On the router/fw there is a sit tunnel thats started with 'ip'.

The clients get their addresses by radvd which only uses a local
interface on the router/fw...

> --yoshfuji

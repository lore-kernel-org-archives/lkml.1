Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYKEUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYKEUcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYKEUcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:32:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:43049 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbYKEUcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:32:06 -0500
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Collins <paul@burly.ondioline.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       James Cloos <cloos@jhcloos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <87skq6sc0e.fsf@burly.wgtn.ondioline.org>
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	 <1225152347.8004.49.camel@pasglop> <m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	 <1225662539.8004.237.camel@pasglop>
	 <871vxtthr3.fsf@burly.wgtn.ondioline.org>
	 <1225874361.13603.12.camel@pasglop>
	 <87skq6sc0e.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 07:31:30 +1100
Message-Id: <1225917090.13603.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 23:28 +1300, Paul Collins wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > On Mon, 2008-11-03 at 20:01 +1300, Paul Collins wrote:
> >> I am also experiencing this problem on a PowerBook G4 with an M10.
> >>
> >> 0000:00:10.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] [1002:4e50]
> >> 
> >> Here are the fonts I'm using:
> >> 
> >>         http://ondioline.org/~paul/consolefonts/
> >
> > For some reason, that font gives me "Bad font file format". 
> 
> Odd.  I'm using setfont from Debian's kbd 1.14.1-4 to load it.
> 
> P.S. I haven't had time to play with the 32-roundup thing any further yet.

Hopefully I'll have some time today. I've been using consolechars -f,
I'll try with setfont.

Cheers,
Ben.



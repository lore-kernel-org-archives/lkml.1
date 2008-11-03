Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYKCHfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYKCHfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKCHfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:35:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:58785 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbYKCHfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:35:43 -0500
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Collins <paul@burly.ondioline.org>
Cc: James Cloos <cloos@jhcloos.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <871vxtthr3.fsf@burly.wgtn.ondioline.org>
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	 <1225152347.8004.49.camel@pasglop> <m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	 <1225662539.8004.237.camel@pasglop>
	 <871vxtthr3.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 18:34:49 +1100
Message-Id: <1225697689.8004.245.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 20:01 +1300, Paul Collins wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> > Now, the problem is ... My second son was just born last wed. so I'm
> > pretty unavailable right now. Thus, for .29, I'm tempted to go for the
> > simpler approach which is to blacklist M7's from imageblit acceleration.
> 
> I am also experiencing this problem on a PowerBook G4 with an M10.

Interesting... I actually developed it on a PowerBook G4 with an M10 !
Maybe not the same revision though or maybe not the same fonts.

I'll have to dig a bit, I'm not sure I'll be able to do a proper
fix in time for the current -rc's so we might have to back the
patch off. We'll see what I can come up with this week, I want to
try reproducing here and experimenting if doing that alignment
& clipping helps.
 
> 0000:00:10.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 [Mobility Radeon 9600 M10] [1002:4e50]
> 
> Here are the fonts I'm using:
> 
>         http://ondioline.org/~paul/consolefonts/
> 

Thanks.

One thing you may want to try .. it will result in crap results on
screen but would help telling us if that's the cause, is to hack
radeonfb to round the image size to a multiple of 32 and see if that
stops the lockup.

Cheers,
Ben.


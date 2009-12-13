Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZLMUAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZLMUAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZLMUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:00:33 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:44920 "HELO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754048AbZLMUAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:00:32 -0500
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--HCc:D*org, 0.000-+--H*Ad:D*sourceforge.net,
	0.000-+--H*Ad:D*lists.sourceforge.net
X-Spam-Spammy: 0.999-1--Quick, 0.965-+--H*Ad:U*daniel.vetter,
	0.951-+--H*r:mail.ffwll.ch
Date: Sun, 13 Dec 2009 21:00:18 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@redhat.com>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com, eric@anholt.net, jbarnes@virtuousgeek.org,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091213200017.GA3522@viiv.ffwll.ch>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Dave Airlie <airlied@redhat.com>, Adam Jackson <ajax@redhat.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
	keithp@keithp.com, eric@anholt.net, jbarnes@virtuousgeek.org
References: <200912071830.14697.arnd@arndb.de>
 <1260337087.3658.1.camel@t60prh>
 <200912131218.24426.arnd@arndb.de>
 <200912131230.25781.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912131230.25781.arnd@arndb.de>
X-Operating-System: Linux viiv 2.6.32-05429-gaf7b4d1 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 12:30:25PM +0000, Arnd Bergmann wrote:
> And now it's obvious that my computer hates me. 12 hours of uptime, one reboot
> to check the old other version is broken, it crashes. I reboot into the
> good version, send out the above email and the next minute it crashes again.
> c05422d52ee6b is not the culprit. Sorry Daniel for blaming your patch.

No problem. Looks like your hunting a pretty ugly Heisenbug. There's quite
a interesting blog post by Paul McKenney, esp. the solution to "Quick Quiz 1"
might be usefull in your case:

http://paulmck.livejournal.com/14639.html

Happy Hunting, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

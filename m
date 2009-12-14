Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZLNDhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZLNDhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZLNDhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:37:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:60055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZLNDhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:37:11 -0500
Subject: Re: [git pull] drm nouveau pony for Xmas.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912111516550.3526@localhost.localdomain>
References: <alpine.DEB.2.00.0912111148250.4178@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912111516550.3526@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 14:35:47 +1100
Message-ID: <1260761747.2217.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 15:19 -0800, Linus Torvalds wrote:
> 
> On Fri, 11 Dec 2009, Dave Airlie wrote:
> > 
> > Please pull the 'drm-nouveau-pony' branch from
> 
> PONIES! Yay! I lurve ponies!
> 
> And it works for me too. Needed to get the firmware from the fedora 
> project, and make sure that it loads as a module rather than built in (so 
> that it can find the firmware!), but other than those two gotchas (that 
> are "obvious", but I needed to fail a couple of boots to hammer the point 
> home) it all seems to work.
> 
> Thank you. The squeaky wheel _does_ get greased.

And built-in works beautifully with kms & fbdev on top of it etc...
(real fast console switches ! yay !) if I do

CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
CONFIG_EXTRA_FIRMWARE="/nouveau/xxx.ctxprog nouveau/yyy.ctxvals"

Where xxx and yyy need to be replaced by whatever is relevant to your
hardware.

(In my case nv43. BTW. For the lurkers, it works fine with the
6600 in the PowerMac G5 with an endian fix to the new loader that
I just posted to the nouveau list and which should trickle upstream
soon).

Cheers,
Ben.



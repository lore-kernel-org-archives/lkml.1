Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYI2Xd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYI2Xd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYI2Xds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:33:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54637 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYI2Xdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:33:47 -0400
Date: Tue, 30 Sep 2008 01:33:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Linus Torvalds wrote:

> So yet another week, another -rc. This one should be the last one: we're 
> certainly not running out of regressions, but at the same time, at some 
> point I just have to pick some point, and on the whole the regressions 
> don't look _too_ scary. And -rc8 obviously does fix more of them.

If 2.6.27 is released with e1000e driver corrupting EEPROM contents on 
many systems out there, rendering the cards unusable for most of the 
i-am-not-a-hacker users (and remember, even Dave Airlie bricked his laptop 
completely to death, when trying to restore eeprom contents), well, I 
personally find that very scary.

Intel is working with us on tracking down and resolving the issue, but 
this is not going as well as one would like to see (one attempt, one card 
with completely hosed EEPROM contents ... and restoring the contents is 
not *that* trivial).

Intel has some patches to mitigate the symptoms (even though we still 
don't know who is causing the breakage, but Xorg is the biggest suspect in 
my eyes), but they are neither in your tree nor in any other maintainer's 
queue yet, as far as I know.

-- 
Jiri Kosina
SUSE Labs


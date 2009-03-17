Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZCQO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZCQO6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZCQO6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:58:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58171 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZCQO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:58:07 -0400
Date: Tue, 17 Mar 2009 14:57:53 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090317145753.GA1651@silver.sucs.org>
References: <20090313200657.GA4907@denkbrett.schottelius.org> <20090313204100.GA3554@tuxdriver.com> <20090317075424.GD8777@denkbrett.schottelius.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317075424.GD8777@denkbrett.schottelius.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 08:54:24AM +0100, Nico -telmich- Schottelius wrote:
> 
> Has anyone a clue on howto debug the build environment or
> debugging the kernel before it's getting booted?

If you have a serial console you can probably get output on that. If you
have flipped EMBEDDED to Y then you might also have to enable
EARLY_PRINTK. Another trick might be to turn set
BOOT_PRINTK_DELAY (Kernel hacking -> Delay each boot printk message by N
milliseconds) to something like 2000 and see if you can read/catch the
messages before the kernel reboots...

Failing that start a git bisection (
http://www.kernel.org/doc/local/git-quick.html#bisect or
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf )
from the last good kernel...

-- 
Sitsofe | http://sucs.org/~sits/

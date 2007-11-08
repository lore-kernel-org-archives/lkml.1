Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXKHNux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXKHNux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 08:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXKHNup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 08:50:45 -0500
Received: from jabberwock.ucw.cz ([89.250.246.4]:43580 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbXKHNup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 08:50:45 -0500
Date: Thu, 8 Nov 2007 14:50:42 +0100
From: Martin Mares <mj@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <mj+md-20071108.134746.10051.albireo@ucw.cz>
References: <20071026025407.GA21408@kroah.com> <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com> <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org> <20071030094756.779ac5c0@laptopd505.fenrus.org> <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org> <20071030102820.47a6e365@laptopd505.fenrus.org> <mj+md-20071101.082743.5958.albireo@ucw.cz> <20071101070855.1e8ef975@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101070855.1e8ef975@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> > Maybe we should do all bus scanning with conf1 and then try if
> > MMCONFIG returns the same values?
> 
> that is already in the code today but not nearly enough; there's a ton
> of cases where it's "touch mmconfig and the box is dead"...

Argh.  However I still do not think it is an acceptable reason for breaking
all userspace access to the extended config space.

At the very least, there should be a sysfs toggle to enable MMCONFIG if
root really wishes that (maybe for a particular device, as the drivers
would do).

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Do not believe in miracles -- rely on them.

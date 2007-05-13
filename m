Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXEMSjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXEMSjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbXEMSjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:39:15 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22847 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564AbXEMSjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:39:15 -0400
Message-ID: <46475B4F.2020903@msgid.tls.msk.ru>
Date: Sun, 13 May 2007 22:39:11 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dan Aloni <da-x@monatomic.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513182035.GA10207@infradead.org>
In-Reply-To: <20070513182035.GA10207@infradead.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, May 13, 2007 at 09:23:52AM -0700, Stephen Hemminger wrote:
[]
>> There is already the modprobe blacklist ability in user space.
> 
> doesn't really help if hotplug loads a broken module before you're getting
> a login prompt.

modprobe blacklist is designed especially for this very case: to stop
hotplug loading broken modules. ;)

But yes, in order to use the blacklist, one have to fill in the list
itself, for which one has to log in...

/mjt

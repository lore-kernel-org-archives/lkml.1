Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXCLLTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXCLLTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXCLLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:19:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43176 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965639AbXCLLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:19:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: s2ram still broken with CONFIG_NO_HZ / HPET (macbook pro)
Date: Mon, 12 Mar 2007 12:22:24 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S\. Tsirkin" <mst@mellanox.co.il>, Len Brown <lenb@kernel.org>,
       Tejun Heo <htejun@gmail.com>
References: <1173645941.4204.5.camel@localhost>
In-Reply-To: <1173645941.4204.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121222.25813.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 21:45, Soeren Sonnenburg wrote:
> (sorry if I am CC'ing the wrong people, seemed for me this is related to
> rc-2 regression 5/6)
> 
> After a very long compile sessions (is there something like git bisect
> to speed this up?) to find the config options that break s2ram between
> my minimalistic and full config I finally have some results:
> 
> As soon as I enable
> 
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> 
> s2ram does not anymore return from resume (just hangs).

This probably is related to problems with RCU synchronization.

Please see this thread for reference: http://lkml.org/lkml/2007/3/11/112 .

Greetings,
Rafael

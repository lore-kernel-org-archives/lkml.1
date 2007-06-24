Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXFXRDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXFXRDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXFXRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:03:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45371 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXFXRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:03:31 -0400
X-Originating-Ip: 74.102.207.204
Date: Sun, 24 Jun 2007 12:59:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "upping" a semaphore from interrupt context?
In-Reply-To: <a781481a0706240945j3a8afe8dkbb6b74d92bdedfc4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706241256380.8409@localhost.localdomain>
References: <20070622173839.GB8398@iucha.net>  <200706221934.18436.arnd@arndb.de>
  <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain> 
 <200706231402.03617.arnd@arndb.de>  <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
  <Pine.LNX.4.64.0706231209490.15371@localhost.localdomain> 
 <a781481a0706231016i51c8534q918b4cb89126ede7@mail.gmail.com> 
 <Pine.LNX.4.64.0706241123130.7006@localhost.localdomain>
 <a781481a0706240945j3a8afe8dkbb6b74d92bdedfc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Satyam Sharma wrote:

> Whoa, hold on. But I've been explicitly mentioning *binary*
> semaphores all along!
>
> Of course users who want / allow multiple tasks (but only upto a
> specific maximum number, which is what counted semaphores are all
> about) to be present in a given critical section simultaneously
> would still want to use the _counted_ semaphores, which is why you
> won't see the old "struct semaphores" dying anytime soon.

ah, ok, i've been misreading all this, sorry.  i'm wondering, then,
if, given both mutexes and completions, whether the general semantics
of semaphores can be tightened up at all.  just curious.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

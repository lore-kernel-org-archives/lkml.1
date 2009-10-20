Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZJTTuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZJTTuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZJTTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:50:07 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:55244 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZJTTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:50:06 -0400
X-Greylist: delayed 1989 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2009 15:50:06 EDT
Date: Tue, 20 Oct 2009 21:16:57 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Message-ID: <20091020191656.GA11718@geggus.net>
References: <hbd4dk$5ac$1@ultimate100.geggus.net> <200910172230.13162.elendil@planet.nl> <hbd9v8$7rf$1@ultimate100.geggus.net> <200910190141.50752.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200910190141.50752.elendil@planet.nl>
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop schrieb am Montag, den 19. Oktober um 01:41 Uhr:

> In the mean time I've been able to trace the culprit. Could you please try 
> if reverting 373c0a7e + 8aa7e847 [1] on top of 2.6.31 fixes the issue for 
> you?

Unfortunately not :(

Starting from 2.6.31.4 I did
git revert 373c0a7e
git revert 8aa7e847 and build a new kernel.

The problem persists. The Kernel crashed again, this
time in "swapper".

Regards

Sven

-- 
"I'm a bastard, and proud of it"
                          (Linus Torvalds, Wednesday Sep 6, 2000)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web

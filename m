Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXEIWtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXEIWtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXEIWtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:49:17 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47795
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666AbXEIWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:49:15 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 18:49:15 EDT
From: Rob Landley <rob@landley.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] doc: volatile considered evil
Date: Wed, 9 May 2007 18:47:44 -0400
User-Agent: KMail/1.9.1
Cc: David Rientjes <rientjes@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
References: <516386418.20070501080839@gmail.com> <alpine.DEB.0.99.0705091137310.22593@chino.kir.corp.google.com> <20070509212313.7d61f113@the-village.bc.nu>
In-Reply-To: <20070509212313.7d61f113@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091847.45504.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2007 4:23 pm, Alan Cox wrote:
> arch/foo almost always supports a single compiler too - gcc. We simply
> don't support anything else. We use gcc inlines and features extensively.
> 
> And who cares about such fine detail of C99, did they fix the struct copy
> bug in ANSI C even ? [1]

Um, I've picked up the tinycc baton (in my copious free time) and am slowly 
trying to get it to build a bootable linux kernel.  There's a ways to go, and 
I really have no idea what I'm doing, but I have help and even made a release 
recently (which is already significantly out of date, largely thanks to David 
Wheeler):

http://landley.net/code/tinycc/

Admittedly, a lot of this involves implementing gcc extensions, but gratuitous 
use of them when there's a perfectly good c99 way of doing it isn't 
necessarily a plus.  Fabrice got it as far as tccboot before QEMU ate his 
life, we've improved a bit since then, and there's presumably a finite amount 
of work left to be done...

Rob

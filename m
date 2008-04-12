Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYDLKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYDLKdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYDLKdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:33:16 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:53361 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYDLKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:33:15 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2008 06:33:15 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] Replace completions with semaphores
Date: Sat, 12 Apr 2008 12:31:59 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1207982591.21308.333.camel@localhost.localdomain>
In-Reply-To: <1207982591.21308.333.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121232.00807.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Saturday 12 April 2008, Daniel Walker wrote:
> From my perspective it should be keep completions , and remove
> semaphores.. The problem with semaphores is the lack of a strict API, 
> and loose usage. 

Seconded!

Ask any software engineer, to describe what a semaphore is and
how it behaves. You'll get the full spectrum of possible semaphore
implementation options. Ask any advanced software engineer and he'll
ask "What kind of semaphore?".

So let them die ASAP!

> At times I've spent hours trying to figure out what a semaphore 
> is doing, or suppose to be doing. 

Same here. Or figuring out what kind of semphore behavior the developer
expected.

> If we enforce strict usage of semaphores, then we'll basically reproduce
> mutex usage, and we have a generic mutex already..

Or have different API for using the same semaphores in different 
creative ways. It might be hard to implement lockdep for that :-)

No, I'm happy that Linux has so many more advanced concurrency concepts,
that the pre-dinosaur locking mechanism (semaphore) is usually 
the last on your list.


Best Regards

Ingo Oeser

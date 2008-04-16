Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbYDPQ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbYDPQ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYDPQ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:26:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52582 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYDPQ0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:26:50 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Replace completions with semaphores
Date: Wed, 16 Apr 2008 18:31:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
References: <4803AD91.5020001@firstfloor.org> <200804161807.25582.ioe-lkml@rameria.de> <20080416161652.GK9191@parisc-linux.org>
In-Reply-To: <20080416161652.GK9191@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804161831.10510.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. April 2008 18:16:52 schrieb Matthew Wilcox:
> The basic idea is that you get back a cookie from the kcounter_claim()
> which you have to hand to the kcounter_release() function so it
> knows which one you released.  It's similar to mutex debugging except

So in addition to the kcounter we need to save a token in a data structure?
In fact, there must be a data structure that can house that token. So you
can no longer live with a pointer just to a device descriptor, but every
individual use of a resource must have an associated data structure?

	Regards
		Oliver


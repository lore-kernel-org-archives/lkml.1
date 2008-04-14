Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYDNPJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYDNPJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDNPJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:09:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbYDNPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:09:26 -0400
Date: Mon, 14 Apr 2008 08:08:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
In-Reply-To: <200804120905.50745.bonganilinux@mweb.co.za>
Message-ID: <alpine.LFD.1.00.0804140759190.2820@woody.linux-foundation.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <20080411214257.GA4979@martell.zuzino.mipt.ru> <200804120905.50745.bonganilinux@mweb.co.za>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Apr 2008, Bongani Hlope wrote:
> 
> it is 100% reproducible with rc7 and rc8, I haven't come across the bug with 
> rc9 though..

Argh, I think I see that's going on. I switched the order of some 
operations without thinking about it, and moved a test outside of the 
console lock.

Since you cannot see this on -rc9, can you go back to -rc8 and test this 
patch (instead of the revert) on top of that? I'm pretty sure this is it, 
but it would be good to have it confirmed.

		Linus

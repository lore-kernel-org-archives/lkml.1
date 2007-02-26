Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbXBZBzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbXBZBzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 20:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXBZBzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 20:55:13 -0500
Received: from keil-draco.com ([216.193.185.50]:50789 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbXBZBzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 20:55:11 -0500
From: "D. Hazelton" <dhazelton@enter.net>
To: pavel@ucw.cz
Subject: Re: GPL vs non-GPL device drivers
User-Agent: KMail/1.9.5
References: <MDEHLPKNGKAHNMBLJOLKKEGHBNAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEGHBNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 25 Feb 2007 20:54:50 -0500
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702252054.50396.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 February 2007 19:47, David Schwartz wrote:
<snip>
>
> > Similary, there are many ways to write inline functions present in
> > headers, and no, embedded developer being lazy does not mean they can
> > copy those functions into their proprietary module.
>
> Yes, it does. Have you read Lexmark v. Static Controls? You can take what
> you need to interoperate.

This is apples and oranges, to use your idiom. In that case Lexmark had the 
code in the toner cartridges had to have a specific SHA1 hash in order for 
the printer to recognize them. Because the only way, then, to produce a 
functional toner cartridge for the printer was to *copy* that code *exactly*. 
In the case of a system where this is not the case, then you are free to 
write your own interface functions. If Lexmark had *not* been using a SHA1 
hash to validate that the cartridge was produced by them (and that is the 
real reason - Lexmark wanted to lock users of their printers into buying new 
toner cartridges from them) the case would have gone against Static Controls. 
The Lexmark v Static Controls decision applies only to interfaces where there 
is only, literally, one way to do it. What this means is that, yes, any use 
of the code in a GPL'd product that could be written in another manner is not 
covered by the "interoperability standard" that Lexmark v Static Controls 
describes. (No argument here, people: Lexmark v. Static Controls basically 
says "Since the only way for this replacement toner cartridge to work was to 
have the 'Toner Loading Program' exactly copied from one of the cartridges 
produced by Lexmark doing such is fair use." All application of this 
precedent to other things must show the exact same thing - namely that the 
*one* and *only* way for something you have designed/written to fulfill its 
purpose is to rely on a copy of a copyrighted work.  This ruling *only* 
applies to making computers, peripherals or parts of those peripherals and 
the copyrighted item that makes it interoperable.

Lexmark v. Static Controls does not give people carte blanche to use 
interfaces to programs that could be re-implemented by them without causing 
the output to stop functioning. In the given example the work including the 
GPL'd header file and using its functions is in violation of the GPL if not 
released under the GPL but is distributed. Why? Because unless there was some 
form of lock-in making those functions a requirement for interoperability 
the "Evil Hacker" could have written and used his own versions and his 
plugin/program would still have been interoperable.

DRH

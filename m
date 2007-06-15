Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbXFOWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbXFOWKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXFOWKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:10:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53812 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbXFOWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:10:30 -0400
Date: Fri, 15 Jun 2007 15:10:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-Id: <20070615151026.2a15e622.randy.dunlap@oracle.com>
In-Reply-To: <20070615191804.GC8151@cvg>
References: <20070614184836.GA6520@cvg>
	<20070615045111.GU943@1wt.eu>
	<46721F18.8090303@intel.com>
	<a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
	<Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
	<20070615173206.GA8151@cvg>
	<4672D246.2040306@nortel.com>
	<20070615110326.b0762b7a.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
	<20070615191804.GC8151@cvg>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 23:18:04 +0400 Cyrill Gorcunov wrote:

> [Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
> | 
> | On Jun 15 2007 11:03, Randy Dunlap wrote:
> | >> 
> | >> "use tabs for indents and spaces for alignment"
> | >> 
> | >> If that means you need to use two dozen spaces, then so be it.
> | >
> | >I don't think that's what that rule means, but I didn't write it,
> | >so I'm not absolutely sure about it.
> | >
> | >but we know that tab stops are every 8th character, not 4 :)
> | 
> | Hardly.
> | 
> | 
> | 
> | 
> | 	Jan
> | -- 
> | 
> 
> Jan, as I see from CodingStyle:
> 
> 	"Tabs are 8 characters, and thus indentations are also 8 characters."
> 
> Actually it would be perfect to get strict rules also for math. and log.
> operators being splitted on several lines:

I disagree that CodingStyle should contain such strict rules for
line continuations.

> 	if (long_name_a || long_name_b ||
> 	    long_name_c)
> 
> 		or
> 
> 	if (long_name_a || long_name_b
> 	    || long_name_c)
> 	
> 	
> 	a = b + c + d + e +
> 	    f;
> 
> 		or
> 
> 	a = b + c + d + e
> 	    + f;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbXFOU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbXFOU2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXFOU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:28:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:23869 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXFOU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:28:08 -0400
Date: Fri, 15 Jun 2007 22:28:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
In-Reply-To: <4672EC53.50409@intel.com>
Message-ID: <Pine.LNX.4.64.0706152222270.32724@fbirervta.pbzchgretzou.qr>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu>
 <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <4672EC53.50409@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 12:45, Kok, Auke wrote:
>> 
>> Well tabs should _never_ be assumed to be 8, and in this regard, as I see it,
>> CodingStyle has a bug. Tabs are there so that the user can set their width
>> according to _their_ taste, simply so that both sides,
>> 
>>  from CodingStyle:
>>  Tabs are 8 characters, and thus indentations are also 8
>>  characters.  There are heretic movements that try to make
>>  indentations 4 (or even 2!) characters deep, and that is akin
>>  to trying to define the value of PI to be 3.
>
> again, this is about *indentation* and not about alignment
>
>> Linus (did he wrote that part?) and the heretics both can have their fun
>> without impacting each other. If we wanted to force the user to have exactly
>> 8 screen blanks, we should use spaces throughout.
>
> Linus was friendly enough to give us permission to use tabs. He forces tabs for
> indentation, but leaves it up to everyone else to (1) set their editor to show
> tabs as 2 or 4 or whatever, and (2) use spaces for alignment.
>
> the bottom line here is that we encourage everyone to use tabs=8, and allow
> some degree of freedom for some people to vary this *AND* have decent looking
> alignment for *EVERYONE* by allowing them to use spaces for alignment.

I'll just say "+1", because that's what I meant.


Blame university for mathematical pickiness:

>>  Tabs are 8 characters, and thus indentations are also 8

is wrong ;-)   --

 *  Tabs _are_ 1 character (use a hex editor and see) and
 *  Tabs _are not always displayed_ as "8 characters"
    [there exists a user for which \t != 8] [not me though]
 *  Tabs _are displayed_ as _much characters as the user specifies_.

(CodingStyle could need a clarification.)



	Jan
-- 

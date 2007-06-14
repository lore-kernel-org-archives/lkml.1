Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbXFNQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbXFNQc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXFNQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:32:21 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:51852 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbXFNQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:32:21 -0400
Message-ID: <46716D8E.2050007@citd.de>
Date: Thu, 14 Jun 2007 18:32:14 +0200
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: /dev/loop* devices not appearing in /dev (at least since 2.6.22-rc3*)
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com> <20070614145206.58fdec91@localhost> <e85b9d30706140710x5671fa12n5845172d4ce32a10@mail.gmail.com> <20070614172234.7f636307@localhost> <20070614154448.GC4155@tatooine.rebelbase.local>
In-Reply-To: <20070614154448.GC4155@tatooine.rebelbase.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt wrote:

> PS: Just wondering: Who came up with this "on-demand" hype?

I don't remember the names, but i remember the root causes. Here we go:

The discussion started when someone with a CD-Server ran out of loops as 256 was the "fixed" maximum.

The other "root"-cause was that the data-structure for the loop-devices was fixed in size at load-time, so after you load the loop-module you couldn't change anything.

 From "increasing" the maximum to <don't remember, but wasn't that much better> the discussion went to dynamic allocation.
Dynamic allocation has the added nicety that there is a bit less waste of resources, in case you don't need so many loops and that you can scale to a large number of loops if you need to.

When all the bugs and usability problems are shaken out, everybody is happy, especially the members of the "i need massive amounts of loops"-fraction.

So much for the background.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYDRQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYDRQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYDRQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:25:18 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:61327 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYDRQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:25:17 -0400
Date: Fri, 18 Apr 2008 12:24:46 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.25
In-reply-to: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
To: Matthew <jackdachef@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Message-id: <200804181224.47198.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2008, Matthew wrote:
>Hi everyone, hi Linus,
>
>congratulations on this new great kernel-release :)
>
>I've another "regression" to report for 2.6.25:
>
>it's concerning much higher temperatures being read out by the
>"coretemp" kernel-module in comparison to 2.6.24* series
>
>e.g. where temperatures were around 40-47°C they are now constantly
>jumping around 55-70°C (even in idle !)
>
>several other users/testers have reported this issue too (both on
>zen-sources [heavy patched] & latest gentoo-sources) [slightly
>patched]:
>
>http://forums.gentoo.org/viewtopic-t-684812-highlight-.html
>
>if I understood git right it (also) happens in conjunction with an 3
>weeks old acpi-snapshot
>(http://repo.or.cz/w/linux-2.6/zen-sources.git?a=heads) integrated in
>zen-sources
>
>I can "reproduce" this on an Intel Core 2 Duo 6600 (Conroe) with a P5W
>DH Deluxe mainboard (by Asus) since at least 2.6.25-rc8 (or possibly
>also rc7)
>
>the temperatures on mobile core (2) duo intel processors [e.g. an
>T7500] seem to be read out correctly - I can't tell it exactly but
>this seems to be an entirely "cosmetical" issue
>(hopefully it's not the opposite and the values are now read out
>correctly since such high temps would be very worrying ;) )
>
>Keep up the great work & please don't forget your growing amount of
>linux-desktop users :)
>
Amen on that.  And to add confusion here, my makeit script started dying when 
I do a remake after changing a config option, cuz it can't find a System.map 
file to delete, even if I copy it in from /boot.  I had to delete the make 
clean line of the script. Odd.

>Regards
>
>Mat
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Check it out, send me comments, and dance joyously in the streets,
	-- Linus Torvalds announcing 2.0.27

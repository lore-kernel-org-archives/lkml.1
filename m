Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYHFNig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYHFNig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYHFNiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:38:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45575 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYHFNiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:38:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4899A931.2020701@s5r6.in-berlin.de>
Date: Wed, 06 Aug 2008 15:37:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>	<Pine.LNX.4.64.0808051140150.6309@anakin>	<33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>	<200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <4899A313.7020708@tmr.com>
In-Reply-To: <4899A313.7020708@tmr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>>> and we already have kgdb so you have to also explain why you
>>> can't improve kgdb in the areas it trails mdb.
>>>
>>> But the ideal outcome would be if you could contribute patches to
>>> kgdb to the point where it is as good as mdb. It is already in the
>>
> That idea sounds familiar, the "suspend2" response, when something new 
> and significantly different is offered, instead of putting it in and 
> letting people choose in configuration, take the position that what is 
> there is good enough, and if the author of the new solution will just 
> drop all their ideas and slap some band-aids on the existing code it 
> will be "gooder enough" without actually offering people a choice of 
> something different.

To be fair, choice in "leaf" features like a debugger is not entirely 
comparable to choice in central features.  If the infrastructure does 
not support all use cases reasonably well, its better to fix the 
infrastructure or replace it by a working one, rather than adding a 
second infrastructure which is also not general enough.

In this case:  Make a side-by-side comparison of features and 
shortcomings of the available debuggers (as in Andi's response), then 
decide how the best of both worlds can be achieved + used + maintained 
most easily --- by having both side-by-side, or by taking over some or 
all of one's features into the other.  Either way requires contributors 
to be interested.
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/

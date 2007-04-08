Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXDHXBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXDHXBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 19:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXDHXBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 19:01:40 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:60860 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXDHXBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 19:01:39 -0400
Message-ID: <461973AD.5060906@student.ltu.se>
Date: Mon, 09 Apr 2007 00:58:53 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: johnrobertbanks@fastmail.fm
CC: Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com
Subject: Re: Reiser4. BEST FILESYSTEM EVER - Christer Weinigel
References: <46157B5B.5000602@gmail.com>   <1175817921.18400.1183285196@webmail.messagingengine.com>   <461592FB.5060507@zytor.com>   <1175819681.20754.1183287946@webmail.messagingengine.com>   <461596DE.2020802@zytor.com>   <1175823288.25662.1183293506@webmail.messagingengine.com>   <4615C780.5040407@zytor.com>   <1175833931.8916.1183307802@webmail.messagingengine.com>   <20070407191715.GG3510@csclub.uwaterloo.ca>   <1175993097.32498.1183512070@webmail.messagingengine.com>   <m3zm5jebad.fsf@zoo.weinigel.se> <1176069053.31062.1183584012@webmail.messagingengine.com>
In-Reply-To: <1176069053.31062.1183584012@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, I'm impressed. Think you got the record on how many mails you 
referenced to in a reply... But dude, please calm down, the caps-lock is 
not the answer. You have got some rude answers and you have called them 
back on it + you have repeated the same statement several times, that is 
not the best way of convincing people.

I believe you picked up the "anti-Reiser religion"-phrase from previous 
rant-wars (otherwise, why does that "religion"-phrase always come up, 
and (almost) only when dealing with Reiser-fs), and yes, there has been 
some clashes caused by both sides, so please be careful when dealing 
with this matter.

Would you be willing to benchmark Reiser4 with some compressed 
binary-blob and show the time as well as the CPU-usage? And document how 
it is set up so it can be reproduced. After all, Windows is suppose to 
be more stable, maintained and cost-efficient then Linux, but they don't 
tell us how ;)

>> since it can't benefit as much from similarity between
>> files. So if that is the case and you really want to save diskspace you
>> almost have to look at read-only compressed filesystems such as cramfs,
>> squashfs, zisofs, cloop and various other variants in combination with
>> a unionfs overlay to get read/write functionality.
>>
>> But in the end everything is a tradeoff. You can save diskspace, but
>> increase the cost of corruption. 
>>     
>
> You deliberately ignored the fact that bad blocks are NOT dealt with by
> the filesystem,... but by the operating system. Like I said: If your
> filesystem is writing to bad blocks, then throw away your operating
> system.
>   
I may have missed something, but if my room-mate took my harddrive, 
screwed it open, wrote a love-letter on the disk with a pencil and then 
returned it (ok, there may be some more plausible reasons for 
corruption), is the OS really suppose to handle it? Yes, it should not 
assign any new data to those blocks but should it not also fall into the 
file-systems domain to be able to restore some/all data?


Just my 2c to the pond
Richard Knutsson


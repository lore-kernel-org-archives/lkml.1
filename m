Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZKDG1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZKDG1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZKDG1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:27:22 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:40720 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZKDG1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:27:22 -0500
Message-ID: <4AF11EC7.70302@codefidence.com>
Date: Wed, 04 Nov 2009 08:27:19 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Valdis.Kletnieks@vt.edu, Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ori Finkelman <ori@comsleep.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
References: <5765.1257270611@turing-police.cc.vt.edu> <4AF07024.80103@gmail.com> <4AF08292.7090102@codefidence.com> <Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:

> On Tue, 3 Nov 2009, Gilad Ben-Yossef wrote:
>
>   
>> Eric Dumazet wrote:
>>
>>     
>>> Valdis.Kletnieks@vt.edu a écrit :
>>>   
>>>       
>>>> Seen right after I started 'fetchmail'.  Reproducible - 3 out of 3.
>>>> I'll bisect this tonight if nobody jumps up and yells they know what it
>>>> is...
>>>>     
>>>>         
>> Bah... this is most probably my fault. Sorry about that.
>>
>> Can you please try the patch in the next email?
>>
>> But also, can you please send me the route table in effect when this happened
>> and the fetchmail command line/config (removing any passwords or account
>> details of course)? I want to understand better when this happens.
>>     
>
> According to the stacktrace, it came from ipv6 side which doesn't have any 
> null checking what so ever atm (you only handled ipv4 correctly). ...You 
> should be a bit more careful next time when adding any BUG_ONs...
>   
I agree, but for my defense I should add this was not just plain 
carelessness, I believed
that the dst_entry cannot be NULL at that location. That was obviously 
wrong. :-(

Gilad





-- 
Gilad Ben-Yossef
Chief Coffee Drinker & CTO
Codefidence Ltd.

Web:   http://codefidence.com
Cell:  +972-52-8260388
Skype: gilad_codefidence
Tel:   +972-8-9316883 ext. 201
Fax:   +972-8-9316884
Email: gilad@codefidence.com

Check out our Open Source technology and training blog - http://tuxology.net

	"The biggest risk you can take it is to take no risk."
		-- Mark Zuckerberg and probably others


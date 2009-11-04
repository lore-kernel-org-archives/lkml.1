Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbZKDGiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbZKDGiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZKDGiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:38:24 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:45641 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZKDGiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:38:23 -0500
Message-ID: <4AF12149.1060305@codefidence.com>
Date: Wed, 04 Nov 2009 08:38:01 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: =?windows-1252?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ori Finkelman <ori@comsleep.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
References: <5765.1257270611@turing-police.cc.vt.edu> <4AF07024.80103@gmail.com> <4AF08292.7090102@codefidence.com>            <Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI> <7916.1257300093@turing-police.cc.vt.edu>
In-Reply-To: <7916.1257300093@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> On Tue, 03 Nov 2009 23:34:19 +0200, Ilpo JÃâ‚¬rvinen said:
>
>   
>> On Tue, 3 Nov 2009, Gilad Ben-Yossef wrote:
>>
>>     
>>> Eric Dumazet wrote:
>>>
>>>       
>>>> Valdis.Kletnieks@vt.edu a écrit :
>>>>   
>>>>         
>>>>> Seen right after I started 'fetchmail'.  Reproducible - 3 out of 3.
>>>>> I'll bisect this tonight if nobody jumps up and yells they know what it
>>>>> is...
>>>>>     
>>>>>           
>>> Bah... this is most probably my fault. Sorry about that.
>>>
>>> Can you please try the patch in the next email?
>>>       
>
> Tried while at home, machine panic'ed.  No netconsole here at the moment, sorry.
>   

Ok, thanks.That is ... strange.

I didn't manage to recreate this here with a simple IPv6 set and netcat
as server client but I will try further, but if there is any way to send me
the crash location that would be a big help. Thanks.
>   
>
> Why was this blowing chunks in the IPv6 when I was making an IPv4 connection
> then? I just noticed that. My fetchmail can't make an IPv6 TCP connection to
> our IMAP server because the server isn't v6-enabled yet.  And although I
> contact our DNS over IPv6, but that's UDP not TCP.
>
>   
I don't think the chunk blowing occurred due to the connection to the IMAP
server. That codes deals with incoming SYNs. I guess it happened when 
fetchmail
tried to connect to the local mail daemon and this should be happening 
over the loopback interface...


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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYAFRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYAFRnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYAFRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:43:39 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:38221 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYAFRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:43:39 -0500
Message-ID: <47811320.3040500@student.ltu.se>
Date: Sun, 06 Jan 2008 18:42:56 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: Re: [patch 1/5] Introduce __WARN()
References: <20080105190713.73745ec6@laptopd505.fenrus.org>	<20080105190840.48a8c2c5@laptopd505.fenrus.org>	<4780BF38.3010902@student.ltu.se>	<20080106074202.3c25b115@laptopd505.fenrus.org>	<4780FD48.4030505@student.ltu.se> <20080106091031.420c355d@laptopd505.fenrus.org>
In-Reply-To: <20080106091031.420c355d@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 06 Jan 2008 17:09:44 +0100
> Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>
>   
>>>> (btw, wouldn't 'var != 0' actually be the proper semantic instead
>>>> of playing with '!'s?)
>>>>     
>>>>         
>>> no because var could be a pointer for example...
>>>   
>>>       
>> You mean because in that case it would be '!= NULL', do you? Sorry,
>> do not see your point here.
>>     
>
> my point is that you don't know which one to use.. 
>   
Sorry to be a bother, but why is that relevant? Except semantics, they 
are the same, right? So what problem would it be if you send it a 
pointer? The '!' uses the same "argument/reason" when given a pointer ;).
> But this isn't new discussion (nor something I'm changing at all); this has come
> up since way back in 2005 :)
> If you feel strongly of changing this, feel free to post a patch; for now I much
> rather leave things as they are right now.
>   
Oh o-well, in such case I may come back and do a larger patching 
someday. Just though since you were in the neighborhood...

Have a good evening
Richard Knutsson


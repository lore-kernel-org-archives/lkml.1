Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYJQQ52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYJQQ52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbYJQQ5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:57:19 -0400
Received: from mail.collax.com ([82.194.105.242]:35119 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698AbYJQQ5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:57:19 -0400
Message-ID: <48F8C3EC.1030607@collax.com>
Date: Fri, 17 Oct 2008 18:57:16 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com>
In-Reply-To: <48EACC91.8040008@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 17102008 #1180489, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

the last weeks I tried to come up with some way to circumvent my 
problems by aimlessly poking around in the code. Did not work though. 
Not yet at least. :)
Maybe it makes more sense for me to wait until you have a solution.
My whole project is stalled right now because of this and I'm not sure 
what next.
Do you plan to change something there soon? If so I would stop wasting 
my time with hopeless attempts.

My problem is at the moment that I don't really know what to do. If you 
can give some aim I would be glad if I could do something.

Thanks

Casey Schaufler wrote:
> Tilman Baumann wrote:
>> Casey Schaufler wrote:
>>> Tilman Baumann wrote:
>> This might work well in trusted networks.
>> But Internet is untrusted and needs to work too. At least in the most 
>> real world scenarios. :)
> 
> Yes. I'm pretty close to convinced that it needs to be included as
> part of the single-label host solution. Not that it can possibly be
> excused in any real secure environment mind you.
> 
>>>> If i set /smack/nltype to 'unlabled' i don't even get SYN packets 
>>>> out. (operation not permitted)
>>>
>>> That's probably a bug, but I think the "fix" is to disable the 
>>> ability to
>>> set the nltype to anything other than CIPSO at least for the time being.
>>
>> Well, there is a case statement in smack_lsm.c that checks for the 
>> nltype (smack_net_nltype) and omits net labeling if cipso is not set.
>> This seems to be a very sensible thing to do. I strongly advice for a 
>> way to omit netlabel based access control.
> 
> Yes, I hear you.


-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942

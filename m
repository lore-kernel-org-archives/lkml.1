Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYJALaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYJALaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYJALaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:30:05 -0400
Received: from mail.collax.com ([82.194.105.242]:50848 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYJALaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:30:02 -0400
Message-ID: <48E35F36.4030203@collax.com>
Date: Wed, 01 Oct 2008 13:29:58 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com>
In-Reply-To: <48E19D01.9050809@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 01102008 #1142380, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
>> Casey Schaufler wrote:
> If you really want to be abusive you could replace the smack_access()
> function in security/smack/smack_access.c (of all places) with a no-op
> returning 0 in all cases.

I thought of that too. :)
But i would rather like to use the thing in it's intended function 
sometime in the future.

>> What I then to is write iptables OUTPUT chain matches which match for 
>> any of these labels and set some connection marks and firewall marks.
>> Which I then can use in routing rules to give different routing rules 
>> to specific processes. (Like all proxy traffic over a second DSL line)
>>
>> I know, it's totally crazy. But it seems to work. :)
>> I just hope the security part of this all will not break anything. But 
>> it does not look like it would right now.
> 
> Smack will eventually bite you if you're not careful, but users of
> MAC systems wouldn't be surprised by that.
Speaking of the devil...
This is exactly what happened to me right now. I have problems with 
_some_ https connects. The problem lies somewhere in openssl.
I did not yet find any clue with strace.
Is there some straight forward way to audit/debug LSM interventions?

I have probably missed something that a labeled process could not do as 
a '_' process could. Have no idea right now, but it is probably 
something stupidly simple.

> I don't think it's crazy,
> I think it's a matter of using what's available in novel ways.
I like that attitude. :)

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942

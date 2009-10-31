Return-Path: <linux-kernel-owner+w=401wt.eu-S1750989AbZJaEJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbZJaEJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 00:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZJaEJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 00:09:35 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:38676 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750710AbZJaEJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 00:09:34 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: Rn_bTpwVM1m4zoXYz1tsinM6DX7srgetNuJNQGT8IAgdalgabZabF0qf6.IshEhD94RPwCgIT585_Ze_rmUaMrx5XhVRx8kTTkB_AsVXJ5cF_0c9iVCc4YOZ8WynNJ6ZwYilS_hppq_Zq6zbMpk_bAi9htKgJeagOZK8ChhYbcmqavGNVNemvVq.tXGnrNeZ55kZTBvfxymC8lGagLGJmL6DwdW1Bcps01gFIwVhKy2ZTtYrtJa7hBEmfikK4F6dJSS2i1URJxLBPE1jlrtCFQwMQ_qAHKZm.xYF02WrcpUsOLvDotAs_90-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AEBB86F.3090601@schaufler-ca.com>
Date: Fri, 30 Oct 2009 21:09:19 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: David Wagner <daw-news@cs.berkeley.edu>, linux-kernel@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <4AE87292.20802@schaufler-ca.com> <hcahnb$mgp$1@taverner.cs.berkeley.edu> <4AE91658.9090105@schaufler-ca.com> <20091030140745.GC1481@ucw.cz>
In-Reply-To: <20091030140745.GC1481@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>
>   
>>> Perhaps take a look at Pavel's post describing the attack again?
>>>       
>> Yeah, I did that. It still looks like the complaint is that
>> /proc/8675309/fd/3 gives you the ability to gain RW access to
>> an object for which you have RW access.
>>
>> Look, with hard links and the various mount options available
>> today you just can't count on setting the mode on a directory
>> to completely protect the files that it references. Look carefully
>>     
>
> Look again. I can count on paths if I can prevent mounts and
> hardlinks.

But you can't. I refer you back to the long and tedious arguments
against pathname based access controls. At any given time the only
access controls that you can actually count on are those on the
object itself.


>  Mounts are irrelevant as they are root-only,

That hardly makes them irrelevant. It makes them explicable, and
thus generally acceptable, but as always, with privilege comes
responsibility.

> and I was checking for hardlinks.
>   

So that was not an issue in this particular case.

>> Now, ask me if I think that /proc/8675309/fd/3 is a good idea,
>> and we'll have a different discussion, but from an old school
>>     
>
> Cool, so we actually agree, and can drop this thread?
> 								Pavel
>   

The "fd" file system was introduced in SystemV long before Linux
was on anyone's radar. It was a response to the fact that a born
shell script (not Born Again SHell, SHell) couldn't redirect to
arbitrary descriptors the way that csh could. It was an amazing
example of every problem looking like a nail to the wielder of
the special purpose file system hammer. I dislike the /proc/.../fd
scheme for the same reasons, not because it is a security issue.
I would have preferred that the shell code get improved instead.
But, as I say, my opinion and $4.35 will get you the beverage of
your choice at Starbuck's.


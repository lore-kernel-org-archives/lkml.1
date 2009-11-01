Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZKAWFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZKAWFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZKAWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:05:52 -0500
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:46089 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753452AbZKAWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:05:51 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: YpafB1gVM1n3.p6PNFQCO3xRhHTAf.PiNCIKEuLxzwKBX3NiFkFoeRZXhJee8UQJT_QU7FRCsU2OgsFEymwBP.V3dJoL2mpQxA2Naop1du3M3Dhp8_.0dSKJsCU8L3FH8dxedPcvBTTe5H5jKV8d_9QkitFLRDE9SsrBXO1cRRIl2SoBnAZUudFPegLlanYbyGZmjjHkLGNl1yRRv2I38wf6gG0R4T9rfY5z.2EvP5NaxVZW9OVkUW5gbX1Tf4LvO4mJBNFRaEa5QgGvDFwyB_4pm3aWsxtSnZtcWpt.FvOR1_Z43H1kcOeDKRN.04gR4jVJ.ummfDEFr5wvIi0SqowMju33v2B8RQtRLtO5MLlg7DVc7UqdmBcfaQidDM4njERkyXR9VDARqQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AEE0643.2090003@schaufler-ca.com>
Date: Sun, 01 Nov 2009 14:05:55 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Wagner <daw-news@cs.berkeley.edu>
CC: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz> <4AEBB86F.3090601@schaufler-ca.com> <hcjk2m$v46$1@taverner.cs.berkeley.edu> <4AEDC8DD.4080806@schaufler-ca.com> <hckrm2$6bl$1@taverner.cs.berkeley.edu>
In-Reply-To: <hckrm2$6bl$1@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> Casey Schaufler  wrote:
>   
>> David Wagner wrote:
>>     
>>> Pavel has provided a concrete attack script.  If you believe
>>> that the protections afforded by that script can be circumvented,
>>> how about showing us the specific attack, described to a similar
>>> level of concreteness and specifity, that demonstrates how to
>>> upgrade the read-only fd to a read-write fd without using /proc?
>>>
>>> Put another way: if you are right that the arguments about
>>> pathname based access controls apply here and lead to the
>>> conclusions you are espousing, then you should be able to
>>> exhibit a specific, concrete, fully specified attack on Pavel's
>>> script, without using /proc.  Right?
>>>       
>> No. The going in premise, that the behavior is a security flaw,
>> is incorrect.  The mode bits on the file allow the requested access.
>>     
>
> I see.

Good.

>   May I conclude that you are unable to answer my challenge?
>   

I don't care about your challenge. The challenge is not relevant.

> I challenged you to show exactly how else a non-root user could gain write
> access to the file, in Pavel's script, other than using /proc/../fd/...
>   

It does not matter if there is no other way to achieve the result.
The reality is that the file system security model allows the access.

> Based on the fact that you have repeatedly declined to answer this
> challenge, it sounds like I can safely conclude that you do not know of
> any other way that a non-root user can accomplish this, in the situation
> Pavel outlines.
>   

Great Godfrey Daniels! I have declined to address your challenge
because it is completely pointless.

> So, it sounds like we have agreement that:
>
>   * In the situation Pavel outlines, a malicious non-root user
>     given read-only access to the file can use /proc/../fd/.. to
>     upgrade that fd to read-write access.
>   

You don't have to introduce malice. The rules allow the access.
I understand that you don't like the implication of the rule.

>   * If /proc/../fd/.. didn't exist, the non-root user would not have
>     been able to do that.
>   

I understand that you don't like the implications of /proc/.../fd/...
but the rules say that if you have this mechanism it should behave
the way it does.

> So the /proc/../fd/.. mechanism is enabling a malicious user to get
> access that they would not have been able to get in the absence of
> this mechanism.
>
>   

It does not matter if there is no other way to achieve the result.
The reality is that the file system security model allows the access.
There is no need for the user to be malicious. The activity is
allowed by the rules.

> Do you agree with that summary?
>   

No. You are ignoring the system security policy exactly the
same way that I am ignoring the truly unnatural behavior of this
aspect of /proc.

>
> The above are the facts, as I see them.  (In contrast, the following is
> my opinion: It is my opinion that these facts demonstrate that this is
> a security violation.)  But I'm not asking for your feedback about my
> opinion; I'm asking you about the facts.  Do you agree with my statement
> of the facts?
>   

Sorry, but I've been in too many arguments where rational
but inappropriate conclusions have been presented because
the original premise is flawed. Your assertion is that this
is a security exploit, but you have never made an argument
that any aspect of security policy has been violated. That
is the "fact" I care about. Show me the policy violation.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   


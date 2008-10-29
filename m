Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYJ2QM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYJ2QM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYJ2QMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:12:48 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:25407 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753654AbYJ2QMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:12:47 -0400
X-YMail-OSG: LZ_Us6QVM1mLzRZ65NkRpx1ycHhR35OfKBwthJVzYIxByur8QLVuGX.FRrLB8nUobxrm03kqm9l5cE1ryfWKwH4D1oLQTtVMCrWZaFwGKKTcUX3_EY83dfgCDa1C0YRW2M2AOMJ0VrtWQaxhtCy0rwvbv1AlBKzAW7haHIg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49088B73.2080208@schaufler-ca.com>
Date: Wed, 29 Oct 2008 09:12:35 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rob MacKinnon <c4blem0nkey@gmail.com>
CC: rob.mackinnon@gmail.com, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, hpa@zytor.com, hugh@veritas.com,
       linux-kernel@vger.kernel.org
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <200810272153.56301.agruen@suse.de> <49062EC0.4040809@gmail.com> <4906A871.6010501@schaufler-ca.com> <49088797.3060802@gmail.com>
In-Reply-To: <49088797.3060802@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob MacKinnon wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Casey Schaufler wrote:
>   
>> Rob MacKinnon wrote:
>>     
>>> Andreas Gruenbacher wrote:
>>>  
>>>       
>>>> On Monday, 27 October 2008 21:25:31 Stephen Smalley wrote:
>>>>    
>>>>         
>>>>> Looks like a bug in Smack's implementation of the inode_listsecurity
>>>>> hook to me.  Did you mean to enable Smack in your kernel config?
>>>>>       
>>>>>           
>>>> Yes, there is at least one bug there; this kernel is broken. You may
>>>> want to try booting with a kernel command line option like
>>>> "security=none", which *should* turn smack off.
>>>>
>>>> Andreas
>>>>     
>>>>         
>>> All,
>>>
>>> Indeed the kernel cmdline option security=none did disable smack. So
>>> atleast that works. Thank you all for helping me track this down.  I can
>>> now return to updating packages (some of which have been waiting
>>> patiently for this to be cleared up)!  Though I will be looking forward
>>> to this feature working as it was intended. ;)  Let me know if there is
>>> a bug # assigned and I'll quietly return to lurking... ;
>>>       
>> It looks like a trivial fix and the patch is here. I have just started
>> testing it myself, but if I don't send it now it will be Wednesday before
>> I do. No sign-off because I haven't verified it, but I would be delighted
>> if you would pass judgement on its efficacy. Thank you.
>>
>>     
>
> All,
>
> Applied, compiled, and tested clean on a P4 Prescott. I'll try this a
> little later on my x64. Thank you for this fix, and thank you all for
> just a fast response

We aims to please. Thank you for the work you put in. That, and everyone
who jumped in to help identify the problem.



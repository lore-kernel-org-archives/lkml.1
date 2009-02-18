Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZBRRJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZBRRJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBRRJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:09:28 -0500
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:35969 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751566AbZBRRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:09:27 -0500
X-YMail-OSG: 2KsRb6sVM1nSVWHWMuEGkKFoy9UwLqS70kM4d2sqlleOMu_CYrmfVSp0wdx7P.RV8p1C6empVVBkBEDlpIVTfzdamRxQpAwmSg_euHF3jgNCZFaFzOaiq1TE40k7CuvctulrPx.CqJ2YwXhOUAX4BgOTEOl6bZ_FXoVDUIDuH2tCzhmBoZwa5LiKrym6Yq5uX_TBSNQA2HgFgHWhOYKO7cRMzowtCY0l0Zd4WYwhhLH3z5FOmMycYiaWVWg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499C40C1.20106@schaufler-ca.com>
Date: Wed, 18 Feb 2009 09:09:21 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com>
In-Reply-To: <200902181005.24952.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Wednesday 18 February 2009 02:23:24 am etienne wrote:
>   
>> ... anyway, I think the cleanest way would be to, well, sort smk_netlbladdr
>> by mask on insertion (perf doesn't matter  here) and this way
>> smack_host_label can stop the loop on first match. Plus, it would give a
>> nicer /smack/netlabel ouptut :)
>>     
>
> Agreed.
>   

Yes, it would make it nicer. You'll need to do a better job
on the list management than I've been doing. It's probably well
past time to introduce the Standard list management scheme to
Smack, and you'll need to do so if you want to do insertions
and/or deletions.

>> so, how should we handle it? apply the patches (with whitespaces damages
>> corrected ;) )  now (as it corrects a bug) an elaborate the cleaner way
>> later?
>>     
>
> Well, since you have some time and willingness to do things "the right way" I 
> would recommend dropping these patches (which are really just band-aids) and 
> working on the right solution to stored the addresses/masks in a sorted list 
> with the mask already applied.
>
> FWIW, the NetLabel code (net/netlabel) has to do very similar things with 
> sorted address lists so I built an address list construct which builds on the 
> list.h ideas and operates in a similar way.  You may find it helpful.
>
>   
>> I think this should go to stable too?
>>     
>
> I would worry about getting the patches developed, tested and in an acceptable 
> form first, then we can worry about where they should be applied ;)
>
>   

I would be delighted to see these changes. When you have preliminary
versions I would be eager to see them and give them a try in the
Smack test laboratory.

Etienne, thank you very much for the work you've done so far. Paul,
thank you for your recommendations.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZLCIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZLCIgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZLCIgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:36:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZLCIge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:36:34 -0500
Message-ID: <4B17793F.7050708@redhat.com>
Date: Thu, 03 Dec 2009 16:39:27 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Cong Wang <amwang@redhat.com>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
Subject: Re: [Patch] selinux: remove an unreachable line
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain> <1259653523.21388.7.camel@Joe-Laptop.home> <4B14D468.2090502@redhat.com> <20091202123558.GC5224@bicker>
In-Reply-To: <20091202123558.GC5224@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On Tue, Dec 01, 2009 at 04:31:36PM +0800, Cong Wang wrote:
>> Joe Perches wrote:
>>> On Tue, 2009-12-01 at 02:41 -0500, Amerigo Wang wrote:
>>>> This line is unreachable, remove it.
>>> []
>>>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>>>> index b5407f1..a2f1034 100644
>>>> --- a/security/selinux/ss/mls.c
>>>> +++ b/security/selinux/ss/mls.c
>>>> @@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
>>>>  	default:
>>>>  		return -EINVAL;
>>>>  	}
>>>> -	return -EINVAL;
>>>>  }
>>> I think it's better to remove the default case.
>>>
>> This is totally a personal taste, I think.
>> Either is OK. James, any comments?
> 
> I think the last unreachable return might also stop certain
> versions of gcc complaining about control reaching the end of
> a non void function.

Hmm, aren't those version of gcc buggy? Here we have return values
in all cases of 'switch', it shouldn't complain...


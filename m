Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZLBMgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZLBMgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZLBMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:35:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37713 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZLBMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bC637GcCglB2EINcDBFqyLno4nlFcTz9jSipDRUHD6sZB8Fkmsm+0FllqY2mjnbexu
         mXJ06loRRA+a1nVdE0rJE5HzdJXyBqbCL/3lIh8hp0e5WMr28N+m27TEpR2NqLYwTCGV
         A//UK8UbeSCBnWP4Gd5eOUZmUXHClMzE3yzV8=
Date: Wed, 2 Dec 2009 14:35:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
Subject: Re: [Patch] selinux: remove an unreachable line
Message-ID: <20091202123558.GC5224@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Cong Wang <amwang@redhat.com>, Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
	linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
	James Morris <jmorris@namei.org>
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain> <1259653523.21388.7.camel@Joe-Laptop.home> <4B14D468.2090502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B14D468.2090502@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 04:31:36PM +0800, Cong Wang wrote:
> Joe Perches wrote:
>> On Tue, 2009-12-01 at 02:41 -0500, Amerigo Wang wrote:
>>> This line is unreachable, remove it.
>> []
>>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>>> index b5407f1..a2f1034 100644
>>> --- a/security/selinux/ss/mls.c
>>> +++ b/security/selinux/ss/mls.c
>>> @@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
>>>  	default:
>>>  		return -EINVAL;
>>>  	}
>>> -	return -EINVAL;
>>>  }
>>
>> I think it's better to remove the default case.
>>
>
> This is totally a personal taste, I think.
> Either is OK. James, any comments?

I think the last unreachable return might also stop certain
versions of gcc complaining about control reaching the end of
a non void function.

regards,
dan carpenter

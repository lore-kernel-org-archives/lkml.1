Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZLAI2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZLAI2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZLAI2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZLAI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:28:43 -0500
Message-ID: <4B14D468.2090502@redhat.com>
Date: Tue, 01 Dec 2009 16:31:36 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
Subject: Re: [Patch] selinux: remove an unreachable line
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain> <1259653523.21388.7.camel@Joe-Laptop.home>
In-Reply-To: <1259653523.21388.7.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2009-12-01 at 02:41 -0500, Amerigo Wang wrote:
>> This line is unreachable, remove it.
> []
>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>> index b5407f1..a2f1034 100644
>> --- a/security/selinux/ss/mls.c
>> +++ b/security/selinux/ss/mls.c
>> @@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
>>  	default:
>>  		return -EINVAL;
>>  	}
>> -	return -EINVAL;
>>  }
> 
> I think it's better to remove the default case.
> 

This is totally a personal taste, I think.
Either is OK. James, any comments?

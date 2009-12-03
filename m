Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZLCIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZLCIf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZLCIf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:35:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZLCIf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:35:26 -0500
Message-ID: <4B1778EB.3070605@redhat.com>
Date: Thu, 03 Dec 2009 16:38:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] selinux: remove an unreachable line
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain> <1259653523.21388.7.camel@Joe-Laptop.home> <4B14D468.2090502@redhat.com> <alpine.LRH.2.00.0912012131440.27592@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0912012131440.27592@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Tue, 1 Dec 2009, Cong Wang wrote:
> 
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
> Leave the default: there but with a comment /* fall through */
> instead of the return.
> 

Ok, will do, thanks.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZGGRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZGGRCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZGGRCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:02:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbZGGRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:02:36 -0400
Message-ID: <4A538037.1010806@redhat.com>
Date: Tue, 07 Jul 2009 20:04:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v4] KVM support for 1GB pages
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com> <4A537C12.2040501@redhat.com> <20090707165248.GR5380@amd.com>
In-Reply-To: <20090707165248.GR5380@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 07:52 PM, Joerg Roedel wrote:
>> I would really like to have shadow 1GB work, or at least gain some
>> understanding of why it doesn't.
>>
>> Can you detail the changes compared to the previous round?
>>      
>
> Until now I addressed the review comments from the previous round. The
> biggest change is patch #4 which was completly rewritten.
> I understand that it would be nicer to have shadow paging working too.
> But since most users will use this feature only on processors with
> nested paging (only processors with nested paging support gbpages) I
> don't think it should be a show-stopper. YMMV.
>    

Right.  I don't think 1GB+shadow is useful in its own right.  It's not a 
barrier for merging (but still very desirable).  I do want more 
information on how it fails though.

> Anyway, I will further try to get shadow paging support running and
> stable.
>    

Great, thanks.

-- 
error compiling committee.c: too many arguments to function


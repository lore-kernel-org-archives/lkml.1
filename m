Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZHDIrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZHDIrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZHDIrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:47:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZHDIrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:47:42 -0400
Message-ID: <4A77F6EF.8010002@redhat.com>
Date: Tue, 04 Aug 2009 11:53:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davidel@xmailserver.org, gleb@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RFC 2/2] eventfd: EFD_STATE flag
References: <cover.1248803500.git.mst@redhat.com> <20090728175538.GC21549@redhat.com> <4A76FDB2.7080706@redhat.com> <20090803151426.GA3630@redhat.com> <4A770260.5000507@redhat.com> <20090803165708.GB3630@redhat.com>
In-Reply-To: <20090803165708.GB3630@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 07:57 PM, Michael S. Tsirkin wrote:
>> Why not do it at the point of the write?
>>
>>      if (value != ctx->count) {
>>          ctx->count = value;
>>          wake_things_up();
>>      }
>>      
>
> What if write comes before read?
>    

The read will get the new value.

-- 
error compiling committee.c: too many arguments to function


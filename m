Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZJHQVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZJHQVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbZJHQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446AbZJHQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:21:40 -0400
Message-ID: <4ACE1175.1010706@redhat.com>
Date: Thu, 08 Oct 2009 18:21:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] KVM: SVM: Add tracepoint for invlpga instruction
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com> <1254996199-17667-8-git-send-email-joerg.roedel@amd.com> <4ACE0CF3.7090101@redhat.com> <20091008161815.GF14073@amd.com>
In-Reply-To: <20091008161815.GF14073@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 06:18 PM, Joerg Roedel wrote:
>
>> Also, kvm tracepoints don't use '=' in TP_printk(), please keep it
>> consistent.
>>      
> I had it with "key: value" formating first but decided to do it this way
> because it simplifies automatic parsing of these trace events. With this
> format a script can first split by spaces and get the key-value pairs by
> splitting on the equal sign. This is also more robust against changes in
> the format.
>
>    

Automatic parsing should use the binary transport (which simply has the 
TP_struct things).

-- 
error compiling committee.c: too many arguments to function


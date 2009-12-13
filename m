Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZLMKPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZLMKPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 05:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZLMKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 05:15:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27303 "HELO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752056AbZLMKPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 05:15:34 -0500
Message-ID: <4B24BEBC.2020207@redhat.com>
Date: Sun, 13 Dec 2009 12:15:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adam Huffman <adam.huffman.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: KVM related crash
References: <ec55d96f0912090600u4ff02e06m1506530d4161f280@mail.gmail.com> <20091212191101.669ba881.akpm@linux-foundation.org>
In-Reply-To: <20091212191101.669ba881.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2009 05:11 AM, Andrew Morton wrote:
> (networking cc's added)
>
> On Wed, 9 Dec 2009 14:00:04 +0000 Adam Huffman<adam.huffman.lkml@gmail.com>  wrote:
>
>    
>> Have seen multiple crashes on a new Dell Precision T7500 workstation,
>> seemingly related to KVM:
>>      
> Looks like a networking crash to me - that CPU just happened to be
> running some KVM code when the interrupt happened.
>    

Yes - and I've seen a similar report earlier (also with kvm).

-- 
error compiling committee.c: too many arguments to function


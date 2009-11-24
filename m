Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbZKXOSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbZKXOSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbZKXOSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:18:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbZKXOSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:18:04 -0500
Message-ID: <4B0BEB00.5090703@redhat.com>
Date: Tue, 24 Nov 2009 16:17:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: kvmmmu tracing
References: <1258974375.7094.158.camel@johannes.local>	 <4B0BAC76.3080202@redhat.com> <1259057130.3985.1.camel@johannes.local>	 <4B0BB6B1.5010302@redhat.com> <1259071713.3491.2.camel@johannes.local>
In-Reply-To: <1259071713.3491.2.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 04:08 PM, Johannes Berg wrote:
> On Tue, 2009-11-24 at 12:34 +0200, Avi Kivity wrote:
>
>    
>> Um, C can be easily parsed with a C compiler.  I don't think you can
>> expect it to be a plain format string and argument list.
>>      
> Actually, it turns out that it cannot be parsed even with a C compiler:
>
> ({ const char *ret = p->buffer + p->len; static const char *access_str[]
> = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union
> kvm_mmu_page_role role;
>
> ...
>
> userspace cannot possibly know from this what "union kvm_mmu_page_role"
> is.
>    

We can expose kvm_mmu_page_role, but that's a new can of worms.  And 
it's certainly not meant to be stable across kernel versions.

-- 
error compiling committee.c: too many arguments to function


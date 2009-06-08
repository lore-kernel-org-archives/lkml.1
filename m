Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZFHBeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZFHBeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFHBeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:34:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48617 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZFHBeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:34:03 -0400
Message-ID: <4A2C6B0E.9090702@redhat.com>
Date: Mon, 08 Jun 2009 09:36:14 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain> <20090604014849.6332.35945.sendpatchset@localhost.localdomain> <200906041800.54696.rusty@rustcorp.com.au> <20090607121549.GA31173@elte.hu>
In-Reply-To: <20090607121549.GA31173@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>   
>> On Thu, 4 Jun 2009 11:16:37 am Amerigo Wang wrote:
>>     
>>> Just as the comment said, trim the exception table entries when
>>> module_free() mod->module_init.
>>>
>>> Currently, this is only done for x86. Other platforms should 
>>> also fix it like this (except sparc32).
>>>       
>> I've taken this one to make it more generic.  I'll leave the x86 
>> maintainers to apply the rest.
>>     
>
> I think it makes most sense to handle them together. We have no 
> interacting changes pending in the x86 tree, feel free to pick them 
> up.
>   

Thanks for clarifying.

So, Rusty, could you please take all of these except patch 4/5? Since you
have a much better one to replace that one. :)

Thank you.




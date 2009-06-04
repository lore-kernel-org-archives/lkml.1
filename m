Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZFDJPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZFDJPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZFDJP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:15:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57817 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769AbZFDJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:15:27 -0400
Message-ID: <4A278C62.8000801@redhat.com>
Date: Thu, 04 Jun 2009 16:57:06 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, jdike@addtoit.com, hch@infradead.org,
       mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [Patch 4/5] module: trim exception table in module_free()
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain> <20090604014849.6332.35945.sendpatchset@localhost.localdomain> <200906041800.54696.rusty@rustcorp.com.au>
In-Reply-To: <200906041800.54696.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 4 Jun 2009 11:16:37 am Amerigo Wang wrote:
>   
>> Just as the comment said, trim the exception table entries when
>> module_free() mod->module_init.
>>
>> Currently, this is only done for x86. Other platforms should
>> also fix it like this (except sparc32).
>>     
>
> I've taken this one to make it more generic.  I'll leave the x86 maintainers 
> to apply the rest.
>   

Thank you. But this one depends on the previous, I don't think you can 
apply this without
the previous ones.

It's better to let Ingo take all of these, of coures, if he thinks they 
are fine. :)



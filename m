Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbYCACu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbYCACu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbYCACuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:50:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:20608 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbYCACuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=c+bd+o4ei/i3DFBSnS0428OxUalrOb51O45egs59AQ+humw0mzxiVm/aQd0tR17s+4g79KdWPDCBxWxn8nqMGqSykk5DKAn4M38Ehy2McK+MZNkJDgOZYpClf60yEE3O2bGZtScA2ZH8V8tyumN1P0dMZwMiJFVeqAV5slJoUrY=
Message-ID: <47C8C37D.8060808@gmail.com>
Date: Fri, 29 Feb 2008 20:46:21 -0600
From: Jon Schindler <jkschind@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9] /drivers/net/8390.c replaced init_module&cleanup_module
 with module_init&module_exit
References: <47C66311.7020000@watson.wustl.edu> <20080229172406.ec0f0cd9.akpm@linux-foundation.org> <47C8C052.2040509@gmail.com>
In-Reply-To: <47C8C052.2040509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've also noticed another issue, it appears that I accidentally gave PATCH 2/9 the wrong subject.  Patch 2/9
actually fixes /drivers/net/ac3200.c, while PATCH 1/9 is the one that fixes /drivers/net/8390.c.  
What's the easiest way to fix these two patches?  Do you want to just back out patches 1 & 2 and 
I can send them as part of a different patch set?  If I change the subject for PATCH 2/9, it might
be hard for others to follow this thread.

Sorry for the trouble, I'm still getting familiar the mechanics of patch submission.

Jon
Jon Schindler wrote:
> I'm sorry, ns8390_init_module should be ns8390_module_init.  I'll resend it in the next reply.
> Andrew Morton wrote:
>> On Thu, 28 Feb 2008 01:30:25 -0600
>> Jon Schindler <jkschind@gmail.com> wrote:
>>
>>> Replaced init_module and cleanup_module with static functions and module_init/module_exit.
>> I get
>>
>> drivers/net/8390.c: In function '__inittest':
>> drivers/net/8390.c:60: error: 'ns8390_init_module' undeclared (first use in this function)
>> drivers/net/8390.c:60: error: (Each undeclared identifier is reported only once
>> drivers/net/8390.c:60: error: for each function it appears in.)
>> drivers/net/8390.c: At top level:
>> drivers/net/8390.c:60: error: 'init_module' aliased to undefined symbol 'ns8390_init_module'
>>
>>
> 


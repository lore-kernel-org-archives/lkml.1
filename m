Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYKFKC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYKFKC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYKFKCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:02:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYKFKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:02:50 -0500
Date: Thu, 6 Nov 2008 11:02:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] vmap: cope with vm_unmap_aliases before
	vmalloc_init()
Message-ID: <20081106100234.GM4890@elte.hu>
References: <49010D41.1080305@goop.org> <200810281619.10388.nickpiggin@yahoo.com.au> <4906CBCA.6060908@goop.org> <4911EB5C.4030901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911EB5C.4030901@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0043]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
>> Xen can end up calling vm_unmap_aliases() before vmalloc_init() has
>> been called.  In this case its safe to make it a simple no-op.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Ping?  Nick, Ingo: do you want to pick these up, or shall I send them to  
> Linus myself?

i've applied them to tip/core/urgent and will send them to Linus 
unless Nick or Andrew has objections.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYL3SSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYL3SSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 13:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYL3SS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 13:18:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:52867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752037AbYL3SS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 13:18:28 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX194ET9/RDd4LfYbKw3xlnfspTjgCOX4WOcOLN9CXx
	FRXMQPc8ADzKet
Message-ID: <495A65EF.5050406@gmx.de>
Date: Tue, 30 Dec 2008 19:18:23 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/2] module.c: fix module loading failure of large	modules
 (take 2)
References: <4959346E.7060600@gmx.de> <49593660.2010900@gmx.de> <20081230180724.GA15235@bombadil.infradead.org> <20081230181032.GB15235@bombadil.infradead.org>
In-Reply-To: <20081230181032.GB15235@bombadil.infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> Ugh, I fail at typing, resending for rusty's benefit.
> 
> On Tue, Dec 30, 2008 at 01:07:24PM -0500, Kyle McMartin wrote:
>> [Adding rusty to CC]
>>
>> On Mon, Dec 29, 2008 at 09:43:12PM +0100, Helge Deller wrote:
>>> +unsigned long module_additional_section_size(struct module *mod,
>>> +					     unsigned int section);
>>> +
>> I think this would be more palatable as
>>
>> #ifdef HAVE_MODULE_SECTION_STUBS
>> unsigned long module_additional_section_size(struct module *mod,
>> 	unsigned int section);
>> #else
>> static inline unsigned long module_additional_section_size(struct module *mod,
>> 	unsigned int section)
>> {
>> 	return 0;
>> }
>> #endif
>>
>> and removing the conditional in kernel/module.c, possibly the symbol
>> should be "arch_module_a..." just to make it clear to anyone reading.
>>
>> Anyway, it's up to rusty.
>>
>> Rusty, we'd like to get this patch in, so I can merge the dependent
>> parisc-specific patch.

Rusty, I think I've a cleaner patch for that and will send it soon...

Helge

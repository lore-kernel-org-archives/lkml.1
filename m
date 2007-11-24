Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXKXWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXKXWP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXKXWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:15:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXKXWPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:15:14 -0500
Message-ID: <4748A23D.2070906@zytor.com>
Date: Sat, 24 Nov 2007 14:14:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Chris Malley <mail@chrismalley.co.uk>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
References: <1191368052.17826.40.camel@localhost.localdomain> <1191368106.17826.43.camel@localhost.localdomain> <1191368154.17826.44.camel@localhost.localdomain> <1191368217.17826.47.camel@localhost.localdomain> <1191368399.17826.51.camel@localhost.localdomain> <1191368457.17826.53.camel@localhost.localdomain> <1191404221.17247.15.camel@feisty> <1191456175.8268.6.camel@localhost.localdomain> <1195941250.2369.5.camel@localhost.localdomain>
In-Reply-To: <1195941250.2369.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kjartan Maraas wrote:
> to., 04.10.2007 kl. 10.02 +1000, skrev Rusty Russell:
>> On Wed, 2007-10-03 at 10:37 +0100, Chris Malley wrote:
>>> Hi guys
>>>
>>> Would it not be clearer to #include <asm/bootparam.h> and use 
>>> the relevant named members of struct setup_header / struct boot_params
>>> rather than the hard-coded values 0x202, 0x1F1, 0x214 ?
>> Yes, but unfortunately bootparam.h wasn't designed to be included from
>> userspace.
>>
> [snip]
> 
> This change seems to have broken build of the battstat applet in
> gnome-applets or rather the included apmlib in there. Intended?
> 
> Any pointers on how to adapt the code in case it was?
> 

Perhaps you could actually give some detail how it broke the code?!

	-hpa

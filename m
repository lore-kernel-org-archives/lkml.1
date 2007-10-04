Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbXJDA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbXJDA1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 20:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXJDA1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 20:27:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbXJDA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 20:27:32 -0400
Message-ID: <47043351.2010708@zytor.com>
Date: Wed, 03 Oct 2007 17:26:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Chris Malley <mail@chrismalley.co.uk>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
References: <1191368052.17826.40.camel@localhost.localdomain>	 <1191368106.17826.43.camel@localhost.localdomain>	 <1191368154.17826.44.camel@localhost.localdomain>	 <1191368217.17826.47.camel@localhost.localdomain>	 <1191368399.17826.51.camel@localhost.localdomain>	 <1191368457.17826.53.camel@localhost.localdomain>	 <1191404221.17247.15.camel@feisty> <1191456175.8268.6.camel@localhost.localdomain>
In-Reply-To: <1191456175.8268.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-10-03 at 10:37 +0100, Chris Malley wrote:
>> Hi guys
>>
>> Would it not be clearer to #include <asm/bootparam.h> and use 
>> the relevant named members of struct setup_header / struct boot_params
>> rather than the hard-coded values 0x202, 0x1F1, 0x214 ?
> 
> Yes, but unfortunately bootparam.h wasn't designed to be included from
> userspace.
> 
> The patch would look like this, but it makes me wonder if it'd be better
> to put all these user-exposed types in bootparam.h and have the other
> headers include them.  hpa?
> 

I don't have a strong preference either way, but I think what you have 
here is fine.

	-hpa


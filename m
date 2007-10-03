Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbXJCRNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbXJCRNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXJCRNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:13:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXJCRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:13:10 -0400
Message-ID: <4703CD7E.30206@zytor.com>
Date: Wed, 03 Oct 2007 10:12:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chris Malley <mail@chrismalley.co.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
References: <1191368052.17826.40.camel@localhost.localdomain>	 <1191368106.17826.43.camel@localhost.localdomain>	 <1191368154.17826.44.camel@localhost.localdomain>	 <1191368217.17826.47.camel@localhost.localdomain>	 <1191368399.17826.51.camel@localhost.localdomain>	 <1191368457.17826.53.camel@localhost.localdomain> <1191404221.17247.15.camel@feisty>
In-Reply-To: <1191404221.17247.15.camel@feisty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Malley wrote:
> Hi guys
> 
> Would it not be clearer to #include <asm/bootparam.h> and use 
> the relevant named members of struct setup_header / struct boot_params
> rather than the hard-coded values 0x202, 0x1F1, 0x214 ?
> 

Yes, please.  I have a patch in -mm which already does that across the 
kernel.

	-hpa

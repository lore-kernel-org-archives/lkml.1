Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYALXe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYALXe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYALXet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:34:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43041 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbYALXes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:34:48 -0500
Date: Sun, 13 Jan 2008 01:33:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew.Morton@hera.kernel.org
Subject: Re: Top 10 kernel oopses for the week ending January 12th, 2008
Message-ID: <20080112233355.GF17276@does.not.exist>
References: <47890B65.80804@linux.intel.com> <20080112222322.GE17276@does.not.exist> <47894999.8060505@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47894999.8060505@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 03:13:29PM -0800, Arjan van de Ven wrote:
> Adrian Bunk wrote:
>>
>> All the other reports only contain the plain trace. Is there any way to 
>> get more information whether the former is a pattern or not, and to
>> get this information somehow displayed on the webpage?
>
> IF the kernel prints that its tainted or whatever it'll be shown, as well
> as the exact versions etc etc if they are there.
> Sadly none of this information is there prior to 2.6.24-rc4.
>...

OK, the problem might actually not be the omission of displaying the 
tainted information but the omission of considering any relevant 
context.

Looking deeper:

Number #2424 is WARN_ON-after-tainted-oops.

Is your rank 1 just a symptom that the system is in a bad state after 
running in what is your rank 8?

In this case the information when following e.g. #2827 is quite useless 
since wherever you got this trace from all related context information 
like e.g. whether it's like #2424 just the symptom of a previous Oops is 
not displayed.

In the worst case, an entry might only contain WARN_ON traces without 
any information where the traces came from and whether it's worth 
looking at them or whether the system always already was in a known-bad 
state when they occured?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


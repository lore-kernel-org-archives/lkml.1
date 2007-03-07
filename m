Return-Path: <linux-kernel-owner+w=401wt.eu-S1161065AbXCGApO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065AbXCGApO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161068AbXCGApO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:45:14 -0500
Received: from terminus.zytor.com ([192.83.249.54]:53546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161062AbXCGApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:45:12 -0500
Message-ID: <45EE0AF7.70502@zytor.com>
Date: Tue, 06 Mar 2007 16:44:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 6/8] Allow per-cpu variables to be page-aligned
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain>	 <1173185909.4644.36.camel@localhost.localdomain>	 <1173186021.4644.38.camel@localhost.localdomain>	 <20070306131522.GC9031@elte.hu> <1173226608.4644.59.camel@localhost.localdomain>
In-Reply-To: <1173226608.4644.59.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> AFAICT, we could save the wasted partial page in three ways: by trying
> to link it first, if it's only a case of one file, by having a special
> page-aligned percpu data section, or by having a smarter linker.
> 

We already do the second of those for conventional data, so it would 
make sense for percpu as well.  Smarter linker would be better, but ugh, 
I don't see that happening any time soon.

	-hpa

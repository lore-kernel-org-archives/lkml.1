Return-Path: <linux-kernel-owner+w=401wt.eu-S1767323AbXDFAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767323AbXDFAav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767451AbXDFAav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:30:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767323AbXDFAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:30:50 -0400
Message-ID: <46159480.20108@zytor.com>
Date: Thu, 05 Apr 2007 17:29:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Define EFLAGS_IF
References: <1174533374.2713.104.camel@localhost.localdomain> <46159256.1040705@zytor.com> <461592AA.4060103@goop.org>
In-Reply-To: <461592AA.4060103@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> That patch got dropped, and replaced by one which pulled all the flags
> definitions out of <asm/processor.h>
> 

Saw that a little too late :)

In general, it would be nice if the various CPU constants were all 
defined in one place, so I'd rather suggest protecting the appropriate 
parts of asm/processor.h with #ifndef __ASSEMBLY__.

	-hpa

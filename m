Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXLRReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXLRReV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXLRReM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXLRReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:34:12 -0500
Message-ID: <476802CB.5050503@zytor.com>
Date: Tue, 18 Dec 2007 09:26:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH 13/21] [PATCH] change bitwise operations to get a void
 parameter.
References: <11979319641796-git-send-email-gcosta@redhat.com>	 <11979320252102-git-send-email-gcosta@redhat.com>	 <11979320302030-git-send-email-gcosta@redhat.com>	 <200712181618.43852.rusty@rustcorp.com.au> <5d6222a80712180440l72faa8fere9588ea6894cf1cb@mail.gmail.com>
In-Reply-To: <5d6222a80712180440l72faa8fere9588ea6894cf1cb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On Dec 18, 2007 3:18 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Tuesday 18 December 2007 09:52:36 Glauber de Oliveira Costa wrote:
>>> This patch changes the bitwise operations in bitops.h to get
>>> a void pointers as a parameter. Before this patch, a lot of warnings
>>> can be seen. They're gone after it.
>> No, this is a backwards step!  These warnings are important for
>> non-arch-specific code: I fought hard to get them made into unsigned longs.
>>
>> But I'm happy for this to be applied as is, then I'll grab the git tree,
>> revert it and fix the warnings...
>>
> Even before my processor.h patches, there are a lot of warnings caused by this.
> If Ingo does not mind getting more warnings, I can drop this patch
> entirely, and you (or someone else)
> can fix them later on.

For any code that can be executed on a bigendian processor, those are 
real bugs.  For littleendian-only code they're arguably nuisance 
warnings, but still...

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXLRFoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXLRFoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXLRFoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXLRFn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:43:59 -0500
Message-ID: <47675CF1.5070008@zytor.com>
Date: Mon, 17 Dec 2007 21:38:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH 13/21] [PATCH] change bitwise operations to get a void
 parameter.
References: <11979319641796-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <200712181618.43852.rusty@rustcorp.com.au>
In-Reply-To: <200712181618.43852.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 18 December 2007 09:52:36 Glauber de Oliveira Costa wrote:
>> This patch changes the bitwise operations in bitops.h to get
>> a void pointers as a parameter. Before this patch, a lot of warnings
>> can be seen. They're gone after it.
> 
> No, this is a backwards step!  These warnings are important for 
> non-arch-specific code: I fought hard to get them made into unsigned longs.
> 
> But I'm happy for this to be applied as is, then I'll grab the git tree, 
> revert it and fix the warnings...
> 

Yes, it's particularly nasty as it'll work fine on littleendian arches, 
and fail on bigendian arches...

	-hpa

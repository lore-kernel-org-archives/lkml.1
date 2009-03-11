Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZCKBro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZCKBro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZCKBrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:47:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZCKBrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:47:35 -0400
Message-ID: <49B71814.2090604@zytor.com>
Date: Tue, 10 Mar 2009 18:47:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
References: <49B703D4.1000008@zytor.com> <87fxhkg8qn.fsf@basil.nowhere.org>
In-Reply-To: <87fxhkg8qn.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> I'm thinking again about removing zImage support.  An "allnoconfig"
>> kernel (with CONFIG_EMBEDDED=y to expose additional knobs, and
>> CONFIG_BINFMT_ELF=y so it can do anything at all) is currently 487K on
>> i386 -- very close to the upper limit of 512K for zImage.
> 
> An alternative would be to do a concentrated effort to get rid of text bloat
> again. I bet it could be stripped down to much below that again by just
> attacking some low hanging fruit.
> 

That wasn't exactly the point.  The whole point is whether or not we can
reduce the complexity of the code by removing a mode which has few or no
users.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


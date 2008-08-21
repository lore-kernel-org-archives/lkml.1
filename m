Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYHUWAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYHUWAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYHUV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:59:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:35376 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbYHUV7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:59:54 -0400
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <C7EDF44A-277E-4157-B2D6-0DEDCF65AED7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080821.140346.236252915.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] math-emu: Fix compiler warnings
Date: Thu, 21 Aug 2008 16:59:44 -0500
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org> <20080821.140346.236252915.davem@davemloft.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 21, 2008, at 4:03 PM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Thu, 21 Aug 2008 07:50:20 -0500
>
>> Fix warnings of the form:
>> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f1' may be used  
>> uninitialized in this function
>> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f0' may be used  
>> uninitialized in this function
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>
> You should look at the compiler options we use on sparc to build this
> stuff :-)
>
> EXTRA_CFLAGS = -Iinclude/math-emu -w

Yeah, I plan on doing that on PPC once I move over the global include/ 
math-emu files.

- k

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbXCHRnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbXCHRnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXCHRnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:43:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41242 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXCHRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:43:51 -0500
Message-ID: <45F04B6E.9000703@mvista.com>
Date: Thu, 08 Mar 2007 10:44:14 -0700
From: Dave Jiang <djiang@mvista.com>
Organization: MontaVista Software, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, trini@kernel.crashing.org,
       sshtylyov@ru.mvista.com
Subject: Re: [PATCH] x86_64 RESTORE_CONTEXT missing '\n'
References: <20070307204516.GA24095@blade.az.mvista.com> <200703081814.53153.ak@suse.de>
In-Reply-To: <200703081814.53153.ak@suse.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 07 March 2007 21:45, Dave Jiang wrote:
>> The RESTORE_CONTEXT macro is missing the '\n' at the end. It was removed in the
>> previous patch that touched system.h. It causes compile failure if any
>> inline asm is added after the macro. Discovered this when playing with
>> kgdb.
> 
> We went through this several times. kgdb has no business to poke 
> into kernel private macros like this and it shouldn't do that. 
> So fixing kgdb to not require touching the context switch is the right
> change.
> 
> -Andi

In spite of kgdb, shouldn't it have that \n anyways in case some other code
gets added in the future after the macro? Or are you saying that there should
never be any code ever after that macro?

-- 

------------------------------------------------------
Dave Jiang
Software Engineer
MontaVista Software, Inc.
http://www.mvista.com
------------------------------------------------------


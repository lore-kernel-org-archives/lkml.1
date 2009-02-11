Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZBKOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZBKOQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZBKOQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:16:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:60539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZBKOQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:16:22 -0500
Message-ID: <4992DD8E.2080809@kernel.org>
Date: Wed, 11 Feb 2009 23:15:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86: Fix pt_regs passed by value
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <20090211114224.GA23873@elte.hu>
In-Reply-To: <20090211114224.GA23873@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 14:15:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Brian Gerst <brgerst@gmail.com> wrote:
> 
>> Several syscalls and one trap handler currently rely on the pt_regs
>> struct being passed in by value.  This causes problems with stack
>> protector, and can also cause problems with corruption due to tail-call
>> optimization.  Change them to use a pointer to the pt_regs struct
>> instead.
> 
> looks good! Applied them to tip:core/percpu, thanks Brian.
> 
> Tejun, i have added your Acked-by lines. (let me know if that's
> incorrect). The review feedback you gave is correct and can/should
> be addressed in separate patches.

Yeah, sure.  I like the direction.  Brian, are you interested in
pursuing further changes?

Thanks.

-- 
tejun

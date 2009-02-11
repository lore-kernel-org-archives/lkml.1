Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZBKOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZBKOyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZBKOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:54:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:59352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZBKOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:54:11 -0500
Message-ID: <4992E670.609@kernel.org>
Date: Wed, 11 Feb 2009 23:53:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Use pt_regs pointer in do_device_not_available()
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-2-git-send-email-brgerst@gmail.com>	 <499281B5.2070502@kernel.org>	 <73c1f2160902110634m779e16f6he9620a7c6c021d12@mail.gmail.com>	 <4992E3CF.4040100@kernel.org> <73c1f2160902110646o5c76785anb93efab5821eba23@mail.gmail.com>
In-Reply-To: <73c1f2160902110646o5c76785anb93efab5821eba23@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 14:53:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Wed, Feb 11, 2009 at 9:42 AM, Tejun Heo <tj@kernel.org> wrote:
>> Brian Gerst wrote:
>>> I don't quite follow what you are trying to say here.  Are you saying
>>> use the same calling convention for the exception handlers (anything
>>> called from error_code) and system calls?
>> Yeap.
> 
> Doesn't make sense to me, two very fundamentally different things.  I
> supposed you could eliminate the error_code parameter, but that's alot
> of work to remove just one instruction.

I don't think they're fundamentally different.  Well, I guess it all
depends on how you look at it.  Those are just functions called after
kernel entry with register stack frame as argument.  Some might have
more fields others might not.

I don't think having two conventions is too bad, so whether to do this
or not is basically a cleanup decision.  Eh... if you feel like doing
it, please go ahead.  If not, well, maybe somebody will do it someday
(or not).  :-)

Thanks.

-- 
tejun

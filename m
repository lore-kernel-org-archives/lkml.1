Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbYBUUBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbYBUUBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbYBUUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:01:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:63118 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763458AbYBUUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mpUDQzyhe1Kv7D8nQc+t2GihfqWrQCwJtcM4dZ/rz9xdEYeXxVct/0cKjjwXjG8jSX+rkth7l+z3nPcXT+Jw/7i4b+5mhzm4t52OriPDUW54Sv6FRWkgWLVh2nMv5SaktwFJu6bKs/44o+AQ9FOcaxXSdIoNRnNH1P46Wf7EWEc=
Date: Thu, 21 Feb 2008 23:00:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup - use PAGE_SIZE instead of numeric
	constant in boot code
Message-ID: <20080221200058.GC6772@cvg>
References: <20080221195022.GA6772@cvg> <47BDD698.9000906@zytor.com> <20080221195628.GB6772@cvg> <47BDD820.2050602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDD820.2050602@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, Feb 21, 2008 at 11:59:28AM -0800]
> Cyrill Gorcunov wrote:
>> [H. Peter Anvin - Thu, Feb 21, 2008 at 11:52:56AM -0800]
>>> Cyrill Gorcunov wrote:
>>>> This patch replaces 4096 numeric constant with PAGE_SIZE macro.
>>>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>>>> ---
>>>> Text segments of old and new files *are* the same so
>>>> it wouldn't break current kernel.
>>> NAK.
>>>
>>> This is NOT PAGE_SIZE (even though the two values are coincidentally the 
>>> same, for historical reasons.)
>>>
>>> 	-hpa
>>>
>> hmm, why the comment on boot_param structure definition calls
>> it "zeropage"? Anyway really thanks for review and catched this.
>
> Historical reasons... it used to be a "magic page" -- that's long since 
> gone.
>
> 	-hpa
>

Thanks Peter, my fault.

		- Cyrill -

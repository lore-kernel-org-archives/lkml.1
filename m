Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbYBUT5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbYBUT5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYBUT45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:56:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:55296 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYBUT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:56:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YtSJ7GESugHWUziaULbq19fVRKOzFZWC39BpyA0TbsTVTLaW/3P8wchshYdhLEKlMoavUbCOF8gCogVf7xXkOmTC+71XHd/Vr6Vwc3n9y+TOrlI7S/HiYYF0QBUvpQu1raRZBsvpTlSaRXtK1eaX9ZQo94rd/mawtA38boCA7iU=
Date: Thu, 21 Feb 2008 22:56:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup - use PAGE_SIZE instead of numeric
	constant in boot code
Message-ID: <20080221195628.GB6772@cvg>
References: <20080221195022.GA6772@cvg> <47BDD698.9000906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDD698.9000906@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, Feb 21, 2008 at 11:52:56AM -0800]
> Cyrill Gorcunov wrote:
>> This patch replaces 4096 numeric constant with PAGE_SIZE macro.
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>> Text segments of old and new files *are* the same so
>> it wouldn't break current kernel.
>
> NAK.
>
> This is NOT PAGE_SIZE (even though the two values are coincidentally the 
> same, for historical reasons.)
>
> 	-hpa
>

hmm, why the comment on boot_param structure definition calls
it "zeropage"? Anyway really thanks for review and catched this.

		- Cyrill -

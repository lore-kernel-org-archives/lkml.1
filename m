Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYDXInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYDXInh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYDXIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:43:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:63180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYDXIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NrVIXk25ni7bSBgx7oa7UgkdsiSnvEkc4xNQvXlWEDfhWgRg5okdNjiRaOE+ECh044jAZaXVahtsndtiR2ZsZGu8bzTwm6bVp53oP0GKaqRZgs3h/GrKyOHz9e8uwpVITfqrlgmoNYTgvZA+jU6YHOmJOor2ELnIbZcDxnlnR8U=
Date: Thu, 24 Apr 2008 12:42:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs
Message-ID: <20080424084241.GA8624@cvg>
References: <20080424083558.GA7749@cvg> <1209026364.9212.978.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209026364.9212.978.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Woodhouse - Thu, Apr 24, 2008 at 09:39:24AM +0100]
| On Thu, 2008-04-24 at 12:35 +0400, Cyrill Gorcunov wrote:
| > X86_VM_MASK is a kernel specific flag so lets hide it from
| > userland programs
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Since and there's already an #ifdef __KERNEL__ section later on in the
| file, and since X86_VM_MASK isn't used before that, I probably would
| have been inclined to shift it down there instead of adding a new
| #ifdef.
| 
| But maybe I should just stop heckling... :)
| 
| -- 
| dwmw2
| 

I was thought about that too ;) David, I'll recheck this
all today evening (have to go to office now). And please
continue heckling - it allows to make this file in particular
*better*, so I think it's ok ;)

		- Cyrill -

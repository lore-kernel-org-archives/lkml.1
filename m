Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYARBXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYARBXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYARBX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:23:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:48142 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYARBXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ArYKHritc9r9PRysurxhZtpKxVWkd0wzPktnBCm85qtcnQDRZMm271f9PoHiictCWtuNH08OkvaCEmQRciauDFweBttRoP8NZSQ1IyBmICsWq7qT5z4HPuiEzDvQHKD3lqVRZwzq2+QlPMFnXj5vMhOc+/g8G91m1oO3Gxsh8SE=
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <478FFD60.8030303@zytor.com>
References: <1200611078.5724.46.camel@brick>  <478FDE76.3070309@zytor.com>
	 <1200612389.5724.63.camel@brick>  <478FF9F3.9030604@zytor.com>
	 <1200618869.5724.83.camel@brick>  <478FFD60.8030303@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 17:23:23 -0800
Message-Id: <1200619403.5724.88.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 20:14 -0500, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > 
> >>> /* still need a define here, as one is long and one is unsigned long.
> >>>  * but this is another target for unification I guess. */
> >>> #define regs_return_value(regs) ((regs)->ax)
> >> Indeed...
> > 
> > I think this comes out of Roland's patches unifying some names eip/rip,
> > eax/rax, etc.
> > 
> > CC'd in case he felt like more work ;-)
> > 
> 
> Funny, I thought those were mine :-/
> 

*Ahem* my apologies, they are in the x86.git lineup right before the
ptrace work Roland did, guess it's time to get a bigger gitk font.

My bad,

Harvey


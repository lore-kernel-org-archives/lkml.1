Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYEYHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYEYHUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYEYHUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:20:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52257 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYEYHUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:20:45 -0400
Date: Sun, 25 May 2008 09:21:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Fix Immediate Values x86_64 support old gcc (v3)
Message-ID: <20080525072124.GA32250@uranus.ravnborg.org>
References: <48344239.9070003@zytor.com> <20080521160217.GA26974@Krystal> <20080521170150.GA29428@Krystal> <20080521203743.GA12982@uranus.ravnborg.org> <20080521212809.GE6158@Krystal> <20080521214608.GA15136@uranus.ravnborg.org> <20080521215756.GA9869@Krystal> <20080521223842.GE15136@uranus.ravnborg.org> <20080521232430.GA14754@Krystal> <20080522020309.GB19848@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522020309.GB19848@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:03:09PM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
> > asm statements. Fallback on generic immediate values if this compiler is
> > detected.
> > 
> 
> Please replace the previous paragraph in the changelog by :
> 
> GCC < 4, on x86_64, does not accept symbol+offset operands for "i"
> constraints asm statements. Fallback on a memory read in lieue of
> immediate value if this compiler is detected.
> 
> As Peter pointed out, talking of "generic immediate value" is rather
> confusing.

Hi Mathieu

As this is not kbuild related (except fom some minor details)
I do not plan to take this in kbuild.git.
I suggest to push it via Andrew.

You may add an Acked-by: from me though.

	Sam

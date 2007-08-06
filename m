Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbXHFVTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbXHFVTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765776AbXHFVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:19:34 -0400
Received: from 1wt.eu ([62.212.114.60]:1224 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765361AbXHFVTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:19:33 -0400
Date: Mon, 6 Aug 2007 23:16:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Axel Reinhold <axel@freakout.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070806211631.GA14501@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu> <46B75CD0.7080408@zytor.com> <20070806174536.GA12131@1wt.eu> <46B761EC.2050803@zytor.com> <ebf06e6c083df46dabc15454dcd89362@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebf06e6c083df46dabc15454dcd89362@kernel.crashing.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 11:15:08PM +0200, Segher Boessenkool wrote:
> >Well, top-level assembly is usually nasty.  Setting the section in the
> >assembly statement as you said is probably the only thing you *can* do.
> 
> You'll probably need to (at the end of the asm block) restore
> the current section to what it was before (".previous"), too.

Didn't know about this one, thanks for the hint !

> >I don't think there is any requirement that top-level assembly
> >statements get the section set to .text on their behalf.
> 
> Correct.
> 
> 
> Segher

Regards,
Willy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765324AbXHFVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765324AbXHFVP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbXHFVPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:15:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647AbXHFVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:15:19 -0400
In-Reply-To: <46B761EC.2050803@zytor.com>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu> <46B75CD0.7080408@zytor.com> <20070806174536.GA12131@1wt.eu> <46B761EC.2050803@zytor.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <ebf06e6c083df46dabc15454dcd89362@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Axel Reinhold <axel@freakout.de>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Date: Mon, 6 Aug 2007 23:15:08 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, top-level assembly is usually nasty.  Setting the section in the
> assembly statement as you said is probably the only thing you *can* do.

You'll probably need to (at the end of the asm block) restore
the current section to what it was before (".previous"), too.

> I don't think there is any requirement that top-level assembly
> statements get the section set to .text on their behalf.

Correct.


Segher


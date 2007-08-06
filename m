Return-Path: <linux-kernel-owner+w=401wt.eu-S1764845AbXHFSEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764845AbXHFSEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbXHFSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:04:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbXHFSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:04:36 -0400
Message-ID: <46B761EC.2050803@zytor.com>
Date: Mon, 06 Aug 2007 11:01:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu> <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org> <20070806132658.GE10999@1wt.eu> <46B75CD0.7080408@zytor.com> <20070806174536.GA12131@1wt.eu>
In-Reply-To: <20070806174536.GA12131@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> I'm well aware of that, even in the example I wrote to reproduce the issue
> and posted to gcc's bugzilla, I clearly have one function prototype and a
> separate asm statement which contained a label with the function's name.
> 
> So in my opinion, the code above is not buggy. It's dirty (though I did
> not find how to produce the equivalent in a different manner).
> 

Well, top-level assembly is usually nasty.  Setting the section in the
assembly statement as you said is probably the only thing you *can* do.

I don't think there is any requirement that top-level assembly
statements get the section set to .text on their behalf.

	-hpa

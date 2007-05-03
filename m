Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXECHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXECHws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXECHws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:52:48 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42348 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753895AbXECHwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:52:47 -0400
Message-ID: <46399302.3050207@aitel.hist.no>
Date: Thu, 03 May 2007 09:45:06 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>	 <Pine.LNX.4.64.0705011347300.27246@anakin>	 <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com> <46398D1F.1020306@zytor.com>
In-Reply-To: <46398D1F.1020306@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Albert Cahalan wrote:
>   
>> Font size is not a sane place to draw the line. Features are.
>>     
>
> Font sizes are an eminently sane place to draw the line, because the
> crossover is largely determined by the point at which nailing down too
> much memory (kernel memory = unswappable memory) gets too expensive.
>   
But then the sane limit is a number of pages, not "512 glyphs".

And there is no problem if the memory is allocated dynamically
when loading the font.  Americans may then load a 127-glyph
font without wasting memory.  And those who wish to lock down
5MB unswappable memory for a hi-res chinese console can do that too.
Doing so isn't really a problem on a desktop pc.

Helge Hafting


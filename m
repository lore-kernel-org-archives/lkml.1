Return-Path: <linux-kernel-owner+w=401wt.eu-S1767049AbXEBSG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767049AbXEBSG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767047AbXEBSG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:06:59 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50902 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767049AbXEBSG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:06:57 -0400
Date: Wed, 2 May 2007 20:02:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Albert Cahalan <acahalan@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
In-Reply-To: <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> 
 <Pine.LNX.4.64.0705011347300.27246@anakin>  <1178021516.4372.62.camel@daplas>
 <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 11:49, Albert Cahalan wrote:
>>
>> Well, I think the consensus is that anything beyond that should be done
>> in userspace; the main such console daemon was Kon2 last I checked.
>
> Font size is not a sane place to draw the line. Features are.
> The levels of support go something like this:
>
> 0. 7-bit ASCII
> 1. Simple direct-to-font VGA characters.
> 2. UTF-8 and large fonts, but no compositing or wide characters.
> 3. Simple compositing and double-wide characters. (like xterm)
> 4. Right-to-left. (like Kermit95)
> 5. Complex shaping, glyph substitution, and vertical text.
>
> Without large fonts, UTF-8 is 90% pointless bloat.

> Personally I don't even need #1, but I think anything less than #3 is
> really rude toward people outside of Europe+Americas. I especially hate
> to hear Europeans argue against this when they have 100% precomposed
> characters for themselves and appear to have played a role (via ISO votes)
> in denying stuff like the mere 12 precomposed characters needed to use
> the Yoruba language with simple renderers.

0. yes we want that

1. can't tell

2. utf8 yes, many text files are in that encoding.
   large fonts - can't tell, I am fine with the regular vga
   font infrastructure (8x16, 8x8)

3. compositing - no, don't need that,
   wide characters - does not even work in vga. just display a '??'
   and everything is fine.

4. I do not really think this has a future on VC.
   You would also 'need' kerning and that serif combiner thing (complex
   shaping?) for Arabic. At best, Arabic would look as horrible on VC
   as it does in xterm today (no RTL, no serif combiner)

5. Vertical text - who else supports this please? Webpages in languages
   that want to do TTB(top-to-bottom) scripting use html workarounds -
   probably because TTB availability it's not even guaranteed in a
   webbrowser.

In short, the current console is very much OK.


Jan
-- 

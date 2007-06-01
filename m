Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbXFAWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbXFAWRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbXFAWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:17:06 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:52096 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbXFAWRE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:17:04 -0400
Date: Fri, 1 Jun 2007 23:17:00 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: DervishD <lkml@dervishd.net>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070601221700.GA15242@deepthought>
References: <20070601142058.GA2587@DervishD>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070601142058.GA2587@DervishD>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 04:20:58PM +0200, DervishD wrote:
>     Hi all :)
> 
>     I have a do-it-yourself Linux box, and I'm planning to move to UTF8
> (currently I'm using es_ES locale, with latin1 encoding). One of my main
> concerns (apart from programs with little or no utf8 support, which I
> will have to suffer) is kernel handling, because I only use the console;
> I only use X and a terminal emulator if I can't avoid it.
> 
[...]
> 
>     Will the console work as it works now if I can live with latin1
> accented characters only? Is there any terminal emulator *for the
> console*, not for X, that handles utf8? Will I be sentenced to X to be
> able to use my computer with utf8?
> 
 Sure, the console will work (don't know about a console terminal
emulator).  I'm not very keen on compose keys - I find dead
diacriticals (like in X) are usually easier to enter, and I've got
all the dead latin1 accents working on my uk keymap.  Other
diacriticals for normally-latin1 keymaps are a different matter
(e.g. caron, ogonek, dot above) - they could be mapped for a
specific letter on a specific key (e.g. AltGr z for ż ; z with dot
above) but the diacritical modifiers can't be mapped for non latin1,
at least in kbd-1.12.  You can also alter the keymap to allow you do
ISO 14755 input (ctrl+shift+hex_digits) - useful for occasional
characters, if they are in your font and you can remember their
value.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce

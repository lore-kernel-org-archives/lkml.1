Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbYDTOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbYDTOKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbYDTOKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:10:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44625 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYDTOKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:10:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <480B4E97.9030805@s5r6.in-berlin.de>
Date: Sun, 20 Apr 2008 16:09:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <20080419204511.GP20637@parisc-linux.org>
In-Reply-To: <20080419204511.GP20637@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> --- a/Documentation/kbuild/kconfig-language.txt
> +++ b/Documentation/kbuild/kconfig-language.txt
> @@ -104,9 +104,9 @@ applicable everywhere (see syntax).
>    Reverse dependencies can only be used with boolean or tristate
>    symbols.
>    Note:
> -	select is evil.... select will by brute force set a symbol
> -	equal to 'y' without visiting the dependencies. So abusing
> -	select you are able to select a symbol FOO even if FOO depends
> +	select should be used with care.  It can set a symbol
> +	without visiting the dependencies.  By abusing select you are
> +	able to select a symbol FOO even if FOO depends
>  	on BAR that is not set. In general use select only for
>  	non-visible symbols (no prompts anywhere) and for symbols with
>  	no dependencies. That will limit the usefulness but on the

"It can set a symbol without visiting the dependencies." = imprecise

"select will by brute force set a symbol [...] without visiting the 
dependencies." = clear.  So why not leave this portion of the text as it is.

Maybe change
	"equal to 'y'"
to
	"equal to 'y' or 'm'"
or to
	""
to make it entirely correct.
-- 
Stefan Richter
-=====-==--- -=-- =-=--
http://arcgraph.de/sr/

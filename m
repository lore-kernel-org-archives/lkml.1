Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbXHLNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbXHLNLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbXHLNL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:11:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40271 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310AbXHLNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:11:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BF06E1.9000302@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 15:10:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Willy Tarreau <w@1wt.eu>, "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local>	<20070810201704.GI6002@1wt.eu>	<20070810204025.GC29549@fieldses.org>	<20070810205117.GJ6002@1wt.eu>	<20070811141925.GA21866@fieldses.org>	<20070811141718.GK6002@1wt.eu> <20070811201210.f5ba7d4d.rdunlap@xenotime.net>
In-Reply-To: <20070811201210.f5ba7d4d.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 11 Aug 2007 16:17:19 +0200 Willy Tarreau wrote:
>> On Sat, Aug 11, 2007 at 10:19:25AM -0400, J. Bruce Fields wrote:
>>> I was just suggesting that if we took your suggestion of standardizing
>>> on plain text plus some conventions for formatting lists and headers and
>>> such, one easy way to do that might just be to adopt the asciidoc format
>>> (or some subset thereof).  Is there any part of the asciidoc *syntax*
>>> that you object to?
>> Not particularly. It's just slightly less readable as plain text but
>> OTOH produces nice documents when you have a working toolchain. But
>> that's a language which needs to be learned, as every such language.
>> Plain text on the contrary, requires no learning. The conventions are
>> more like suggestions to newcomers. Everyone is free to proceed as he
>> wants, judging by the result while writing the text.

> but if we use something richer than plain text, I think that we
> shouldn't need to invent yet another markup language.
> Just use HTML or asciidoc or MarkDown etc...

*If* we switch to a markup language instead of plaintext (or instead of
plaintext with style recommendations), then submitters should at least
be able to do basic syntax checks without having a toolchain installed.

E.g. provide a scripts/checkdocumentation.p[ly] similar in function to
scripts/checkpatch.pl.  (OK, that one requires a perl interpreter
installed, but that's a fair requirement.)

One note on asciidoc:  I experienced the same as Willy when I wanted to
build git with manpages on a distribution without prebuilt asciidoc.
And when I finally managed to build a minimum asciidoc setup, I was
bitten by a syntax change in the asciidoc language, requiring a small
change to git's documentation source to be compatible with both asciidoc
7.x and asciidoc 8.x IIRC.
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/

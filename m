Return-Path: <linux-kernel-owner+w=401wt.eu-S1763491AbXHNUig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763491AbXHNUig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXHNUi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:38:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35536 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXHNUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:38:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C212AA.1040409@s5r6.in-berlin.de>
Date: Tue, 14 Aug 2007 22:38:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Cal Peake <cp@absolutedigital.net>
CC: Joe Perches <joe@perches.com>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com>  <20070813115344.04759b74@the-village.bc.nu>  <46C06E70.9090905@s5r6.in-berlin.de> <46C0838A.2030504@intel.com>  <1187022904.10249.97.camel@localhost> <1187064798.32555.7.camel@localhost>  <Pine.LNX.4.64.0708140021460.11945@lancer.cnet.absolutedigital.net> <1187066391.32555.27.camel@localhost> <Pine.LNX.4.64.0708140040280.11945@lancer.cnet.absolutedigital.net>
In-Reply-To: <Pine.LNX.4.64.0708140040280.11945@lancer.cnet.absolutedigital.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cal Peake wrote:
> On Mon, 13 Aug 2007, Joe Perches wrote:
> 
>> On Tue, 2007-08-14 at 00:29 -0400, Cal Peake wrote:
>>> Prolly /[^a-z0-9]/i would the safest bet. Also don't forget to escape 
>>> double quotes (e.g. "Jonathan \"Jon\" Doe" <jon@example.net>).
>> A-Z and [[:space:]] are OK too.
> 
> The 'i' at the end of the regex means case-insensitive ;) but yes, I 
> forgot whitespace. So something like:
> 
>   if ($name =~ /[^a-z0-9[:space:]]/i) {
>     quote_name;
>   }
> 
>> I skimmed the spec, but nothing jumped out at me.
> 
> My recommendation was mostly based on what pine does. It seems to be a 
> pretty sane MUA...

Better:  Dig out the respective RFCs or/and use a library (perl module
or whatever) for the recoding into mail header formats.
-- 
Stefan Richter
-=====-=-=== =--- -===-
http://arcgraph.de/sr/

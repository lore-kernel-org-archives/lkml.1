Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXJMMzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXJMMzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXJMMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:55:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48207 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbXJMMzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:55:02 -0400
Date: Sat, 13 Oct 2007 14:55:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: checkpatch: ERROR: Does not appear to be a unified-diff format
 patch
In-Reply-To: <20071013124733.GA4211@stusta.de>
Message-ID: <Pine.LNX.4.64.0710131453530.31913@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710131424470.12088@anakin> <20071013124733.GA4211@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13 2007 14:47, Adrian Bunk wrote:
>On Sat, Oct 13, 2007 at 02:28:00PM +0200, Geert Uytterhoeven wrote:
>> scripts/checkpatch.pl doesn't seem to like this patch:
>> 
>> $ scripts/checkpatch.pl m68k-export-asm-cachectl-h.diff 
>> ERROR: Does not appear to be a unified-diff format patch
>>...
>> --- a/include/asm-m68k/Kbuild
>> +++ b/include/asm-m68k/Kbuild
>> @@ -1 +1,2 @@
>>... ^^
>
>Broken patch, this has to be "-1,1".

No, this is actually how diff outputs it.
/([-+]\d+)\b/ seems to imply /$1,1/

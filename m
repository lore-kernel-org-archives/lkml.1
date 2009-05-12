Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZELVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZELVqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZELVqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:46:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZELVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vrnLgPJwCW48Q7GUOvV3CGSu3UKN6fZEjE5cG7boQgbz9/LC0IQyphBeH10xdaBByS
         hWMzOCTgVEa8yBlp48sT7+i+x15Oad1FgKmmdYOrZpz1REIAu5otW7RT5W6+4Y7T96sT
         igrRfYSrBcNTsKQaXoFPW4clggnhVg3f7rWm4=
Message-ID: <4A09EE13.3020102@googlemail.com>
Date: Tue, 12 May 2009 23:45:55 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Michael Buesch <mb@bu3sch.de>, David Dillow <dave@thedillows.org>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de>	<4A06D8D2.4010505@googlemail.com>	<1242001754.4093.12.camel@obelisk.thedillows.org>	<200905112248.44868.mb@bu3sch.de> <m3eiuufufj.fsf@intrepid.localdomain>
In-Reply-To: <m3eiuufufj.fsf@intrepid.localdomain>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Krzysztof Halasa wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> 
>>Yeah maybe other chips are affected as well.
>>I just want to note that my failing chip/board is an Intel D945GCLF2 board
>>with onboard G-LAN, too.
>>
>>The device XID is: XID 3c4000c0
> 
> 
> I have an on-board RTL8111C (at least the docs say so) with this same
> XID and it's working correctly.

How do lspci and dmesg report the chip? For mine, lspci says it's a
"RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)" while
the kernel reports "RTL8168c/8111c at 0xffffc200000f6000,
00:1c:c0:b6:1a:4a, XID 3c4000c0".

This reminds me of the early ATA/USB bridges from Genesys Logic... many
revisions, and each one broken in a different way. :-(

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little

Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXHMTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXHMTzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbXHMTzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:55:25 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:45956 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762107AbXHMTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:55:23 -0400
Message-ID: <46C0B6AB.5010908@student.ltu.se>
Date: Mon, 13 Aug 2007 21:53:15 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Satyam Sharma <satyam@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <alpine.LFD.0.999.0708132351320.29609@enigma.security.iitk.ac.in> <Pine.LNX.4.64.0708132120520.30582@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708132120520.30582@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 14 2007 00:02, Satyam Sharma wrote:
>   
>> Better solution is to have multiple MAINTAINERS files distributed in the
>> kernel tree, IMHO -- say a drivers/net/MAINTAINERS for maintainer info on
>> all various net drivers, drivers/kvm/MAINTAINERS for KVM maintainer info,
>> fs/ext3/MAINTAINERS for ext3 maintainers, fs/MAINTAINERS for generic VFS
>> maintainers info, so on and so forth. Of course, these individual
>> MAINTAINERS files could still have the newly-introduced "F:" fields as
>> well (drivers/net/MAINTAINERS would clearly require it, f.e.) ...
>>     
>
> Yes please.
>
> Or perhaps even putting the maintainer into the Kconfig files?
>
>   
Hope I am not biting my ass now, but I believed this was suggested but 
the counter-argument were; is really a file/system made to configure the 
kernel related to the maintainer?

I like the idea of ".maintainers" (or maybe even ".maintainer" now). It 
has also been suggested that the file should be at the lowest common 
pathway to avoid duplication. Downside is the added need to search for 
the file...

Richard Knutsson


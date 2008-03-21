Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYCUQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYCUQno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYCUQn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:43:27 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34679 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbYCUQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:43:25 -0400
Date: Fri, 21 Mar 2008 17:43:20 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Malte =?iso-8859-1?Q?Schr=F6der?= <maltesch@gmx.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
Message-ID: <20080321164320.GA32699@fi.muni.cz>
References: <20080214184700.0bd3837d@highlander.home.lan> <47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan> <47BCE71F.2000309@gmail.com> <20080221172757.44882428@highlander.home.lan> <20080317210045.GG3189@fi.muni.cz> <20080318140116.GC8480@fi.muni.cz> <47E08762.9090704@gmail.com> <20080319061958.GK3189@fi.muni.cz> <47E0B46C.6030302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47E0B46C.6030302@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 21 Mar 2008 17:43:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
: Jan Kasprzak wrote:
: > Tejun Heo wrote:
: > : Hmm... I still wanna know why it got broke in the first place.  The only
: > : thing I can think of is IRQ routing problem in which case pci=nomsi or
: > : irqpoll should help.  Any chance you can test the old BIOS?
: > 
: > 	Yes, I can. What data are you interested in? Boot logs with
: > pci=nomsi and irqpoll ? Anything else?
: 
: pci=nomsi, then, irqpoll should be enough for now.
: 
	I have tried to do this, but unfortunately ASUS BIOS flash
utility does not let me to downgrade to the 0906 bios, where the problem
occurs. It lets me only downgrade from 1101 to 100x, but not to 0906
(even when called from the 100x BIOS).

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<

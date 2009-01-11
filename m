Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZAKR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZAKR4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZAKR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:56:00 -0500
Received: from smtp.witbe.net ([81.88.96.48]:46082 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZAKRz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:55:59 -0500
Date: Sun, 11 Jan 2009 18:55:47 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: Linux 2.6.29-rc1
Message-ID: <20090111185547.0200a264@tux.DEF.witbe.net>
In-Reply-To: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 10 Jan 2009 16:13:02 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> The merge window is over, and while it is quite possible that I missed a 
> few merge requests in the crazy week that is behind us, apart from those 
> we should now have most of the bulk of 2.6.29 merged up. And now it's
> just a small matter of making sure it's all stable and ready to go.

Compiz is now refusing to run, and says :
Jan 11 11:22:47 tux kernel: compiz:3330 map pfn expected mapping type
 write-back for d0040000-d0a40000, got uncached-minus

Due to the "write-back" part of the message, I've check /proc/mtrr and it
does contain :
[root@tux log]# cat /root/mtrr-2.6.29-rc1 
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x07f800000 ( 2040MB), size=    8MB, count=1: uncachable
reg02: base=0x07f700000 ( 2039MB), size=    1MB, count=1: uncachable
reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

When running 2.6.28, it does contain :
[root@tux log]# cat /proc/mtrr 
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x07f800000 ( 2040MB), size=    8MB, count=1: uncachable
reg02: base=0x07f700000 ( 2039MB), size=    1MB, count=1: uncachable
reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

so it's exactly the same content.

Is there anything else I should check ?

Regards,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

How do you explain Wayne Newton's POWER over millions?  It's th' MOUSTACHE
...  Have you ever noticed th' way it radiates SINCERITY, HONESTY & WARMTH?
It's a MOUSTACHE you want to take HOME and introduce to NANCY SINATRA!

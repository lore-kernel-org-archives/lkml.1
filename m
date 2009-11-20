Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZKTV2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZKTV2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZKTV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZKTV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:51 -0500
Message-ID: <4B0709D4.6010305@zytor.com>
Date: Fri, 20 Nov 2009 13:27:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
References: <20091116225429.GB4764@const.famille.thibault.fr> <20091116230523.GC24961@x200> <20091116231520.GD4764@const.famille.thibault.fr> <20091117115503.GB1657@x200> <20091117132358.GJ12736@const.bordeaux.inria.fr> <20091119131854.GA1628@x200.localdomain> <20091119132828.GA31025@const.bordeaux.inria.fr> <20091119133737.GE31025@const.bordeaux.inria.fr> <4B055F24.8030307@zytor.com> <20091120190730.GB1434@ucw.cz> <20091120204612.GA31728@elf.ucw.cz>
In-Reply-To: <20091120204612.GA31728@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 12:46 PM, Pavel Machek wrote:
> 
> Like this... But it should probably be slightly more complex -- like
> making numlock/capslock/scrollock leds into trigers, and then
> move input LED lowlevels into drivers/led...
> 

In particular, all keyboard modifiers should be available triggers.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXIOTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXIOTA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXIOTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:00:15 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:5571 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbXIOTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:00:13 -0400
X-ME-UUID: 20070915190012584.8EA201C0009A@mwinf2707.orange.fr
Message-ID: <46EC2BBB.1030506@free.fr>
Date: Sat, 15 Sep 2007 21:00:11 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: HOME
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: =?UTF-8?B?IlBhdWwgUm9sbGFuZCAo44Od44O844Or44O744Ot44Op44OzKSI=?= 
	<rol@witbe.net>
Cc: Rob Hussey <robjhussey@gmail.com>, flamingice@sourmilk.net,
       andreamrl@tiscali.it, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
References: <46EBE70C.2040201@free.fr>	<46EBEBD2.7060502@free.fr>	<6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>	<46EC24B6.2030709@free.fr> <20070915185153.08490a9b@tux.DEF.witbe.net>
In-Reply-To: <20070915185153.08490a9b@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland (ポール・ロラン) wrote:
> Hi Eric,

>> Now I have two side questions:
>> 	- the code is no more symetric "subsys_initcall" -> "module_exit".
>> Do not know if it is "normal" but I love symmetry in code :-). Did not test
>> it still works as a module...
> Symmetry is not broken, as we have :
> #define subsys_initcall(fn)             module_init(fn)
> in include/linux/init.h where compiling as a module, and when not compiling
> as a module, I doubt the exit function is called unless you are shuting
> down your machine...

I came to this conclusion too. But I would have preferred to have
#define subsys_exit(fn)			modules_exit(fn)

in the case of a module and nop in the non module case...


-- eric






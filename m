Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXIOSwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXIOSwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXIOSwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:52:03 -0400
Received: from tag.witbe.net ([81.88.96.48]:58247 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXIOSwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:52:01 -0400
Date: Sat, 15 Sep 2007 18:51:53 +0000
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: eric.valette@free.fr
Cc: Rob Hussey <robjhussey@gmail.com>, flamingice@sourmilk.net,
       andreamrl@tiscali.it, linux-kernel@vger.kernel.org, rol@witbe.net,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
Message-ID: <20070915185153.08490a9b@tux.DEF.witbe.net>
In-Reply-To: <46EC24B6.2030709@free.fr>
References: <46EBE70C.2040201@free.fr>
	<46EBEBD2.7060502@free.fr>
	<6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
	<46EC24B6.2030709@free.fr>
Organization: Witbe.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sat, 15 Sep 2007 20:30:14 +0200
Eric Valette <eric.valette@free.fr> wrote:

> Rob Hussey wrote:
> > On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
> >> Eric Valette wrote:
> >>
> 
> Thanks for your help: it does indeed fix the problem.
Nice it works for you too !
 
> Now I have two side questions:
> 	- the code is no more symetric "subsys_initcall" -> "module_exit".
> Do not know if it is "normal" but I love symmetry in code :-). Did not test
> it still works as a module...
Symmetry is not broken, as we have :
#define subsys_initcall(fn)             module_init(fn)
in include/linux/init.h where compiling as a module, and when not compiling
as a module, I doubt the exit function is called unless you are shuting
down your machine...

> 	- Who takes the responsability to push a patch to Linus? I guess it
> is urgent unless he plans a rc7
Good point ! I expect the patches to be already in some queue waiting to be
pulled !


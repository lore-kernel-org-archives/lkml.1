Return-Path: <linux-kernel-owner+w=401wt.eu-S1765503AbXKPBOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503AbXKPBOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXKPBOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:14:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33957 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXKPBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:14:41 -0500
Date: Fri, 16 Nov 2007 10:13:42 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: EIP is at device_shutdown+0x32/0x60
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <20071115190124.GA29599@suse.de>
References: <3ae72650711150950k74fdb37eu108bb360a594ffe8@mail.gmail.com> <20071115190124.GA29599@suse.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071116100930.5A78.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Care to try this:
> >   +       system_kset = kset_create_and_register("system", NULL,
> >   +                                              &devices_kset->kobj, NULL);
> > 
> > We should not join the kset, only use it as a parent.
> 
> Yes, that fixes the problem for me!
> 
> Can anyone else verify this?

I confirmed it fixed the problem. :-)

Thanks.


-- 
Yasunori Goto 



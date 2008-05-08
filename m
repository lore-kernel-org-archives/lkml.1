Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYEHJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYEHJlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYEHJkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:40:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34108 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYEHJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:40:51 -0400
Date: Thu, 08 May 2008 18:40:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080508012957.c778c8e7.akpm@linux-foundation.org>
References: <20080508163039.0EF4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080508012957.c778c8e7.akpm@linux-foundation.org>
Message-Id: <20080508183902.0EF7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Are you sure? I found the following call chain:
> > > 
> > >   static irqreturn_t power_handler(int irq, void *dev_id)
> > >   ->orderly_poweroff(true);
> > >     ->call_usermodehelper_setup()
> > 
> > sorry, you are right.
> > I'll make patch again.
> 
> How many times do we have to make this mistake :(
> 
> Only the caller knows what allocation mode the callee can use. 
> call_usermodehelper_setup() should be extended to take a gfp_t argument.

Agreed.
I'm testing so patch.
I'll post tommorow, myabe.




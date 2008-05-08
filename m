Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYEHHbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYEHHbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbYEHHbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:31:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48878 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYEHHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:31:47 -0400
Date: Thu, 08 May 2008 16:31:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4822AA6F.5040703@cn.fujitsu.com>
References: <20080508153337.0EEE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4822AA6F.5040703@cn.fujitsu.com>
Message-Id: <20080508163039.0EF4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > Now, call_usermodehelper_setup() use GFP_ATOMIC.
> > but it is slighly odd.
> > because call_usermodehelper() is always called process context.
> > 
> 
> Are you sure? I found the following call chain:
> 
>   static irqreturn_t power_handler(int irq, void *dev_id)
>   ->orderly_poweroff(true);
>     ->call_usermodehelper_setup()

sorry, you are right.
I'll make patch again.




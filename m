Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZIWMiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZIWMiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZIWMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:38:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:35356 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZIWMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:38:52 -0400
Message-ID: <4ABA16BF.4020504@windriver.com>
Date: Wed, 23 Sep 2009 07:38:23 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
References: <20090923163817.44bcebb8.sfr@canb.auug.org.au>
In-Reply-To: <20090923163817.44bcebb8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 12:38:27.0610 (UTC) FILETIME=[BFC537A0:01CA3C4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Greg,
>
> Today's linux-next merge of the usb tree got a conflict in
> arch/x86/kernel/early_printk.c between commit
> 414128bd33fef3242747154dfa444970bc5caf4c ("x86: Increase timeout for EHCI
> debug port reset completion in early printk") from Linus' tree and commit
> bd965307ef6b7a56219f8883d5038f6573a94f6e ("USB: ehci,dbgp,early_printk:
> split ehci debug driver from early_printk.c") from the usb tree.
>
> The latter moved the code that the former modified.  A later USB patch
> used an even longer loop delay.
>
>   
Please, let me know if there is something I need to do here.

Simply changing the context of the patch in Greg's branch should be
enough.   There are many more fixes beyond just the timing loop in the
dbgp series which cover, cold and warm restarts and various errata with
the ehci debug controllers.

Hopefully we can get the dbgp series merged soon because this particular
errata was fixed several months ago.  :-)

Thanks,
Jason.

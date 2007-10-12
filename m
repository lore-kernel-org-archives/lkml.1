Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXJLX3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXJLX3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXJLX3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:29:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43844 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbXJLX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:29:25 -0400
Date: Sat, 13 Oct 2007 01:29:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
In-Reply-To: <20071012155708.d8abd06d.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr>
 <20071012155708.d8abd06d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12 2007 15:57, Randy Dunlap wrote:
>On Fri, 12 Oct 2007 23:44:08 +0200 (CEST) Jan Engelhardt wrote:
>
>> warning("override: %s turns state choice", sym->name);
>
>What does that warning message mean?  I can't decipher it.

It is when the value of a "choice" kconfig object is changed, for example
this .config excerpt:

CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_REEMPT_VOLUNTARY=y

>Other than that, it works for me.  Thanks.

/What/ works, the patch, or the tree without the patch? (Note I was
testing that on 2.6.23.1, not the git head, so if someone silently
merged things behind me, I might have missed it. Then again, that
would have probably caused an offset, fuzz or reject, which was not
the case.)

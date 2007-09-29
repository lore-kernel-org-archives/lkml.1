Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXI2USm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXI2USm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXI2USg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:18:36 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:40415 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbXI2USg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:18:36 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [OT] kbuild syntax extension for ccflags and asflags (was: [PATCH 1/3] CodingStyle updates)
Date: Sat, 29 Sep 2007 22:21:24 +0200
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <20070929110129.307cbd9f.randy.dunlap@oracle.com> <20070929182909.GA19943@uranus.ravnborg.org>
In-Reply-To: <20070929182909.GA19943@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709292221.27534.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Saturday 29 September 2007, Sam Ravnborg wrote:
> Lately I have considered extending the kbuild syntax a bit.
> 
> Introducing
> ccflags-y
> asflags-y
> 
> [with same functionality as the EXTRA_CFLAGS, EXTRA_AFLAGS]
> would allow us to do:
> 
> ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG

Please do!

That is very useful for testing and developing new modules.
I learnt a lot from you in this regard and used that kind
of syntax to the extreme in some other non-kernel project
of mine. There it included also ccflags, asflags and so on.

I further split that into -debug-y and -optimize-y flags,
but that was just for my own convenience.


Best Regards

Ingo Oeser


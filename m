Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXJAUfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXJAUfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXJAUfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:35:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35909 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXJAUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:35:36 -0400
Date: Mon, 1 Oct 2007 22:35:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Extending kbuild syntax
In-Reply-To: <200709301536.57156.ioe-lkml@rameria.de>
Message-ID: <Pine.LNX.4.64.0710012234420.7130@fbirervta.pbzchgretzou.qr>
References: <20070929201145.GA20377@uranus.ravnborg.org>
 <200709301536.57156.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 30 2007 15:36, Ingo Oeser wrote:
>
>> obj-y-ifn-
>
>This is the only one needed, because it is cumbersome to express
>negative rules in kbuild to include stubs (e.g. nommu stuff). 

Perhaps this would work?

ifeq (${CONFIG_NO_MMU},)
obj-m += magic_mmu.o
endif

>But again this can be done with composition rules right now, but
>is order dependent. If we could get rid of this requirement,
>I would be happy already. So kbuild is just lacking an "else" 
>clause here.

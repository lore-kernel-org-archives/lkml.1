Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYHJVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYHJVoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYHJVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:44:08 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41542 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbYHJVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:44:07 -0400
Message-ID: <489F612E.7070400@keyaccess.nl>
Date: Sun, 10 Aug 2008 23:44:14 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
References: <489E0F5A.8010404@keyaccess.nl>
In-Reply-To: <489E0F5A.8010404@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-08-08 23:42, Rene Herman wrote:

> [ Andrew: not submitted ]
> 
> Hi Wim.
> 
> I'm going over a list of drivers that break the boot of randconfig 
> kernels by keeping resources busy:
> 
> http://lkml.org/lkml/2008/8/1/96
> 
> and eurotechwdt and plain wdt are in that list. Below is an eurotechwdt 
> that makes passing in io and irq values mandatory as to keep that from 
> happening.
> 
> I saw pcwd was already isafied and followed that -- due to the comment 
> in eurwdt_release() though, I'm not sure about a .shutdown() method.
> 
> Do you want this in the first place? The randconfig testing does find 
> actual bugs so it is useful.
> 
> I'll do wdt and the other applicable ones in there as well if yes.

Wim, do you want them with the grab when modular, not grab when builtin 
distinction?

Rene.

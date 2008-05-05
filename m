Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYEENrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYEENrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYEENrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:47:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58336 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYEENrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:47:40 -0400
Message-ID: <481F0FFA.8060709@firstfloor.org>
Date: Mon, 05 May 2008 15:47:38 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
References: <20080502091806.GA26062@basil.nowhere.org> <481F0EE1.1000506@sandeen.net>
In-Reply-To: <481F0EE1.1000506@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We've lost the information about how close we are... that'd be nice to
> keep if possible....

If you don't want to fix it then the message was unnecessary and your
threshold was too high. So you should always fix when you see the
message and the how close information is unnecessary. That is why I
dropped it.

> 
> Can we keep the old printk string and pass the remaining stack in as an arg?

It would have complicated the patch.

-Andi


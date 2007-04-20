Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXDTAt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXDTAt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXDTAt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:49:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:37306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXDTAt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:49:28 -0400
To: chris@pcburn.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPL-incompatible Module Error Message
References: <4627EED5.6020800@pcburn.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Apr 2007 03:47:27 +0200
In-Reply-To: <4627EED5.6020800@pcburn.com>
Message-ID: <p73vefr4y1c.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Bergeron <chris@pcburn.com> writes:

> Hello all,
> 
> Building the fglrx module against the current Linux kernel (2.6.20.7
> as of this e-mail) I'm getting an error:
> 
> FATAL: modpost: GPL-incompatible module fglrx.ko uses GPL-only symbol
> 'paravirt_ops'
> 

It should probably be available for non GPL modules too. Otherwise
they can't even disable interrupts, which seems a bit extreme.
I will change that in my tree.

-Andi

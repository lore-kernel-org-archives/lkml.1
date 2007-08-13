Return-Path: <linux-kernel-owner+w=401wt.eu-S972391AbXHMQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972391AbXHMQJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947306AbXHMOpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:45:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S947130AbXHMOpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:45:09 -0400
To: Keith Owens <kaos@ocs.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unbalanced stack usage in arch/i386/math-emu/wm_sqrt.S
References: <11592.1186988776@kao2.melbourne.sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Aug 2007 17:39:16 +0200
In-Reply-To: <11592.1186988776@kao2.melbourne.sgi.com>
Message-ID: <p73odhbiguz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Owens <kaos@ocs.com.au> writes:

> Originally sent to the maintainer of the i386 math-emu code
> (billm@suburbia.net) but that mail was bounced[1].  Is anybody
> maintaining the math-emu code and do we even care about it anymore?

I can take a patch, but I would prefer if it was tested
e.g. by force disabling the FPU and then running a program
to trigger that exception. If there is no test it
might be safer to keep the bug around than to run
untested code.

-Andi

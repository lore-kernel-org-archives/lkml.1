Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbXF2WPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbXF2WPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXF2WPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:15:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbXF2WPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:15:38 -0400
From: Andreas Schwab <schwab@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to determine if the noexec stack is defined by an application
References: <46856F24.5060407@andrei.myip.org>
	<1183153758.2894.1.camel@laptopd505.fenrus.org>
X-Yow: Why was I BORN?
Date: Sat, 30 Jun 2007 00:15:19 +0200
In-Reply-To: <1183153758.2894.1.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Fri\, 29 Jun 2007 14\:49\:18 -0700")
Message-ID: <jefy4aflvs.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> like this:
>
> $ eu-readelf -l /bin/true  | grep STACK
>   GNU_STACK      0x000000 0x00000000 0x00000000 0x000000 0x000000 RW 0x4
>
>
> (replace /bin/true with the binary or library you want to check)
>
> if it says "RW" like here, it'll have non-executable stack. If it says
> "RWX" or if this line is absent entirely, the stack will be executable.

The last part is not true.  Some architectures (especially newer ones)
default to non-exec stack.  The absense of a GNU_STACK header represents
the default.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

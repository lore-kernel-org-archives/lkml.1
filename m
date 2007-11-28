Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXK1PJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXK1PJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXK1PI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:08:57 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41540 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXK1PI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:08:56 -0500
Date: Wed, 28 Nov 2007 10:08:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: -rt doesn't compile for UML
Message-ID: <20071128150840.GB5518@c2.user-mode-linux.org>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 02:09:45PM +0100, Miklos Szeredi wrote:
> kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory

For things like this, look at the host's asm/foo.h and see if it's
usable in UML (and contains things that you need).  If it is, just
make a asm-um/foo.h which just includes "asm/arch/foo.h".

				Jeff

-- 
Work email - jdike at linux dot intel dot com

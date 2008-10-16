Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYJPHyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYJPHyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJPHxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:53:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:51961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYJPHxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:53:49 -0400
From: Andreas Schwab <schwab@suse.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	<20081015.220247.262683261.davem@davemloft.net>
X-Yow: YOW!!  I am having FUN!!
Date: Thu, 16 Oct 2008 09:53:32 +0200
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net> (David Miller's
	message of "Wed, 15 Oct 2008 22:02:47 -0700 (PDT)")
Message-ID: <je3aixvuv7.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

>> net/dccp/options.c: In function 'dccp_parse_options':
>> net/dccp/options.c:67: warning: 'value' may be used uninitialized in this function
>
> Known issue, not trivial to fix, gcc is just being incredibly silly here as it
> can't see all of the control flow.

Seems to be fixed in gcc 4.3.  It actually needs a pretty complete value
tracking to get right.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

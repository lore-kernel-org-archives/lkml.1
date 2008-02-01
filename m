Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbYBANK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbYBANK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbYBANKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:10:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYBANKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:10:48 -0500
Date: Fri, 1 Feb 2008 14:10:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
Message-ID: <20080201131030.GB1477@elte.hu>
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <ijc@hellion.org.uk> wrote:

> Hi Peter,
> 
> This patch switches the payload of a bzImage file to be in compressed 
> ELF format. There are several rough edges which need to be addressed 
> before it could go any further but I'd be interested to hear your 
> opinion of the general approach before I spend time cleaning it up.
> 
> I'm mainly interested in something along these lines to allow the Xen 
> bootloader to load a bzImage so that distros don't have to maintain 
> two kernel packages with the same basic bits in different file 
> formats, I think it would probably be of use to the kexec and/or 
> lguest folks too.

this looks quite interesting to me. Peter, what do you think?

	Ingo

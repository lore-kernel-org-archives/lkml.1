Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZF3V7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZF3V7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZF3V7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:59:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZF3V7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:59:47 -0400
Date: Tue, 30 Jun 2009 23:59:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lenb@kernel.org, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org, feng.tang@intel.com, len.brown@intel.com
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090630215931.GA1241@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com> <20090623072811.GB6397@elte.hu> <20090630145737.de5de4af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630145737.de5de4af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Jun 2009 09:28:11 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > +/*
> > > + * Table structures must be byte-packed to match the SFI specification,
> > > + * as they are provided by the BIOS.
> > > + */
> > > +#pragma pack(1)
> > 
> > We use __attribute__((packed)) for that generally.
> 
> Or __packed.  I usually recommend __packed because I can never 
> remember the weird arrangement of underscores and parentheses in 
> the gcc thing.

Agreed - it's also shorter and more in line with stuff like 
__read_mostly, etc.

	Ingo

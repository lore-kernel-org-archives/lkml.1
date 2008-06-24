Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYFXSAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYFXSAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYFXSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:00:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51400 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbYFXSAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:00:04 -0400
Date: Tue, 24 Jun 2008 20:00:01 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3062D2476@orsmsx505.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0806241959180.26777@ask.diku.dk>
References: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
 <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
 <57C9024A16AD2D4C97DC78E552063EA3062D2476@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Luck, Tony wrote:

> > In addition the current alloc_bootmem() is a macro that uses __alloc_bootmem
> > which most defintely can return NULL.
> 
>         ...
>         panic("Out of memory");
>         return NULL;
> }
> 
> Oops ... that "panic" call before the "return NULL" makes the
> above statement totally wrong.

Thanks.  I was worried there might be somewhere a non-aborting version of 
panic.  But that would be really confusing...

julia


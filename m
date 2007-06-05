Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbXFEVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbXFEVb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXFEVbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:31:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:39358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbXFEVbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:31:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
Date: Tue, 5 Jun 2007 23:31:08 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <200706051837.22847.ak@suse.de> <4665D270.2020301@zytor.com>
In-Reply-To: <4665D270.2020301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706052331.09214.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 23:15:28 H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> > I don't think it's a good idea for the TSC. There are various
> > setups where it is unreliable and also often simulators don't 
> > implement it correctly. And it's always a valuable workaround
> > to be able to turn it off.
> > 
> 
> For all I can tell, if this is the case, then CONFIG_X86_TSC should be
> removed completely.

Yes it should.

> We still support the TSC when CONFIG_X86_TSC is not 
> compiled in; that attribute controls if it is unconditionally required.
> 
> (We seem to still not always use it, which may be a good indication that
> CONFIG_X86_TSC has outlived its usefulness.  Should it be removed?)

Yes.

-Andi

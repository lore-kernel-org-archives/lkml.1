Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXFOVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXFOVyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXFOVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:54:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56068 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXFOVyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:54:31 -0400
Date: Fri, 15 Jun 2007 23:55:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/5] Use EXTRARW_DATA in architectures
Message-ID: <20070615215534.GB11267@uranus.ravnborg.org>
References: <20070615202959.316963297@polymtl.ca> <20070615203550.044690775@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615203550.044690775@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu.

On Fri, Jun 15, 2007 at 04:30:00PM -0400, Mathieu Desnoyers wrote:
> EXTRARW_DATA adds a place to declare rw data that will not be mixed with the
> .data content; therefore limiting data cache pollution when data is put in
> the EXTRARW_DATA sections.

I would suggest to embed this inside DATA_DATA in vmlinux.lds.h
That seems reasonsable to do instead of adding it right after DATA_DATA
for all archs.

>From your patch it looks like I originally missed out
powerpc + xtensa when introducing DATA_DATA - would be nice if
you could fix that.

	Sam

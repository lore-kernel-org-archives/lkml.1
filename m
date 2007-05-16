Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbXEPOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbXEPOoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXEPOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:44:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:36038 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984AbXEPOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:44:28 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       Michael Jones <mlj28@cam.ac.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
References: <464034CF.20700@wpkg.org> <20070516071300.GB14222@infradead.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 16 May 2007 16:44:25 +0200
In-Reply-To: <20070516071300.GB14222@infradead.org> (Christoph Hellwig's message of "Wed, 16 May 2007 08:13:01 +0100")
Message-ID: <m3vees96ba.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Not even trying to support LE is a clear merge blocker.  Maybe Krzysztof
> can't actually test it himself, which is fine - but not even pretending
> to be endian clean is not what proper Linux drivers do.

The drivers can only work with IXP4xx CPU and that's not the typical
endianess problem cross-platform drivers sometimes have.

There is different functionality required with LE mode, unless some
other arch changes are implemented (which I'm now researching, if
I have some time of course).
-- 
Krzysztof Halasa

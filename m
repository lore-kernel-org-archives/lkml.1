Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXBJMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXBJMGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXBJMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:06:23 -0500
Received: from ns.suse.de ([195.135.220.2]:51480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbXBJMGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:06:21 -0500
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070209193753.76bc2430@localhost.localdomain>
From: Andi Kleen <ak@suse.de>
Date: 10 Feb 2007 14:06:40 +0100
In-Reply-To: <20070209193753.76bc2430@localhost.localdomain>
Message-ID: <p73ps8igo0v.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan <alan@lxorguk.ukuu.org.uk> writes:

> Please just push the EDAC K8 stuff. Andi will say "no" from now until the
> end of time, but end users want it, distributions want it, and Andi is
> not the EDAC maintainer so should consider himself overruled on what
> isn't a technical issue but a personal political viewpoint.

Well it's a technical issue -- it conflicts with the machine check
code that is already implemented by stealing away its events.
You would first need a CONFIG_MCE=n on x86-64 at least, otherwise
one of them will be unhappy.

The other issue is that the existing code does everything EDAC
K8 does already perfectly fine, just in a small fraction of 
the code.

-Andi

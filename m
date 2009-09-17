Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbZIQR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbZIQR5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbZIQR5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:57:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbZIQR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:57:44 -0400
Date: Thu, 17 Sep 2009 13:57:30 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ppc64 build failure on fedora
Message-ID: <20090917175730.GB11961@bombadil.infradead.org>
References: <20090917174144.GA11961@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917174144.GA11961@bombadil.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:41:44PM -0400, Kyle McMartin wrote:
> For some reason or another (newer gcc?) on Fedora 12 koji builders we're
> seeing _restgpr0_$n symbols instead of _restgpr_$n as handled in the
> prom_init_check.sh file:
> Checking prom_init.o symbol '_restgpr0_14'
> Error: External symbol '_restgpr0_14' referenced from prom_init.c
> Checking prom_init.o symbol '_restgpr0_17'
> 
> Add cases to handle this to the filter portion of the script.
> 

Sorry, after reading the gcc code for this, I've realized this is
clearly wrong and must be a toolchain defect...

Apologies for the noise.

cheers, Kyle

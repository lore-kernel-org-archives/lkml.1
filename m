Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXI1TgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXI1TgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXI1TgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:36:13 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40776 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbXI1TgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:36:12 -0400
Date: Fri, 28 Sep 2007 15:36:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Generic compat_sys_fallocate
Message-ID: <20070928193610.GC24047@fattire.cabal.ca>
References: <20070928181111.GF22182@fattire.cabal.ca> <20070929050610.GA8880@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929050610.GA8880@osiris.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 07:06:10AM +0200, Heiko Carstens wrote:
> 
> These are not identical... the least and most significant parts seem to get
> passed in a different way on little and big endian machines.
> Maybe it would be worth to have something like compat_merge_64() which does
> the right thing?
> 

yeah, that's what i've just done.

cheers,
	Kyle

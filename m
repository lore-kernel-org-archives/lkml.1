Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbXCKHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbXCKHyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXCKHyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:54:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbXCKHyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:54:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [QUICKLIST 4/6] x86_64: Single Quicklist
Date: Sun, 11 Mar 2007 08:54:05 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ak@suse.com, linux-ia64@vger.kernel.org,
       holt@sgi.com, mpm@selenic.com
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com> <20070311020944.19905.87599.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070311020944.19905.87599.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703110854.05799.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 03:09, Christoph Lameter wrote:
> x86_64: Convert to use a single quicklists
> 
> This adds caching of pgds and puds, pmds, pte. That way we can
> avoid costly zeroing and initialization of special mappings in the
> pgd.
> 
> The first patch just adds a simple implementation using a single
> quicklist. As a consequence we need to zero a pgd before returning
> it to the pool.


This and i386 version are ok to me, although it might be better to just
finish __GFP_ZERO support to do this.

-Andi

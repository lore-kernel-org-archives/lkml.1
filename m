Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0BNTt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:49:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39398
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab0BNTty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:49:54 -0500
Date: Sun, 14 Feb 2010 11:50:07 -0800 (PST)
Message-Id: <20100214.115007.94112348.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] of/sparc: Remove sparc-local declaration of
 allnodes and devtree_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100213160309.4767.94443.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	<20100213160309.4767.94443.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 13 Feb 2010 09:03:09 -0700

> Both allnodes and devtree_lock are defined in common code.  The
> extern declaration should be in the common header too so that the
> compiler can type check.  allnodes is already in of.h, but
> devtree_lock should be declared there too.
> 
> This patch removes the SPARC declarations and uses decls in of.h instead.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>

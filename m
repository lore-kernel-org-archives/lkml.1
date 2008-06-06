Return-Path: <linux-kernel-owner+w=401wt.eu-S1764416AbYFFQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764416AbYFFQkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYFFQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:40:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60483 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758083AbYFFQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:40:35 -0400
Date: Fri, 6 Jun 2008 11:40:34 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 00/18] continued prepartion of XPC/XPNET to support SGI UV
Message-ID: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches takes XPC/XPNET another step in the direction of being
able to run on both sgi-sn2 and sgi-uv hardware. The result of this set of
patches is to isolate the architecture specific code.

This patchset is based on linux-next.

There are more patches to follow.

I can't do anything about the following warning reported by checkpatch.pl.
The symbol being exported resides in drivers/misc/sgi-xp/xp_nofault.S, so the
EXPORT_SYMBOL_GPL(xp_nofault_PIOR) can't even be placed in the same file much
less follow the function.

> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #25: FILE: misc/sgi-xp/xp_sn2.c:25:
> +EXPORT_SYMBOL_GPL(xp_nofault_PIOR);


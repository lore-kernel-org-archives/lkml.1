Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbXEWHFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbXEWHFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWHE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:04:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbXEWHEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:04:55 -0400
Date: Wed, 23 May 2007 08:04:50 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce CONFIG_VIRT_TO_BUS
Message-ID: <20070523070450.GN4095@ftp.linux.org.uk>
References: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 05:01:55PM +1000, Stephen Rothwell wrote:
> Make some offending drivers depend on it and set
> CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.

Seeing how few targets _do_ have that, I'd invert the that.  I.e. have
HAS_VIRT_TO_BUS in arch/*/Kconfig for the few architectures that have
that stuff.

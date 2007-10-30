Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbXJ3CsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbXJ3CsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXJ3CsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:48:09 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:55548 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXJ3CsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:48:07 -0400
Date: Tue, 30 Oct 2007 02:48:01 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030024801.GA19417@linux-mips.org>
References: <20071028201549.GA23138@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028201549.GA23138@fattire.cabal.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 04:15:49PM -0400, Kyle McMartin wrote:

> +++ b/mm/Kconfig
> @@ -172,6 +172,7 @@ config MIGRATION
>  
>  config RESOURCES_64BIT
>  	bool "64 bit Memory and IO resources (EXPERIMENTAL)" if (!64BIT && EXPERIMENTAL)
> +	depends on (MIPS || PPC32 || X86_PAE) || 64BIT

On MIPS it would be a per platform thing.  I'd prefer if RESOURCES_64BIT
was enabled through reverse dependencies and never visible as a user
option.

  Ralf

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYAXG2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYAXG2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYAXG2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:28:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55292 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYAXG2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:28:11 -0500
Date: Wed, 23 Jan 2008 22:29:12 -0800
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] [POWERPC] Always build setup-bus.c on powerpc
Message-ID: <20080124062912.GA22509@kroah.com>
References: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 12:07:32AM -0600, Kumar Gala wrote:
> The common arch/powerpc code calls in to functions in setup-bus.c
> so some builds of ppc32 would fail.
> 
> Note, ppc32 usage of setup-irq.c is limited to arch/ppc and should be
> removed when arch/ppc goes away.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Greg, recent changes that BenH has made to the arch/powerpc pci code make
> this necessary. If you don't have an issue I'd like this patch to go via
> the paulus's powerpc.git tree.

No objection at all.  Feel free to add my:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
to this patch and send it through Paul.

thanks,

greg k-h

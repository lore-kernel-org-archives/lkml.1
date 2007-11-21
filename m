Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXKUJxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXKUJxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXKUJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:53:23 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44692 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXKUJxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:53:22 -0500
Date: Wed, 21 Nov 2007 10:55:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       Jan Dittmer <jdi@l4x.org>
Subject: Re: [PATCH] CRIS: avoid using arch links in Kconfig
Message-ID: <20071121095505.GA1070@uranus.ravnborg.org>
References: <20071121090346.GD14797@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121090346.GD14797@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 10:03:46AM +0100, Jesper Nilsson wrote:
> Improve including of architecture dependent Kconfig files.
> 
> - Always include the architecture dependent Kconfig files.
> - Wrap architecture dependent Kconfig files inside an appropriate
>   "if ETRAX_ARCH_Vxx" block.
> 
> This makes it possible to run the configuration even without the arch links,
> which are created later in the build process.

Looks good!
Getting rid of magic symlinks is always good - especially in the early
config phase.

	Sam

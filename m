Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXEHGZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXEHGZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXEHGZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:25:23 -0400
Received: from lixom.net ([66.141.50.11]:43054 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbXEHGZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:25:22 -0400
Date: Tue, 8 May 2007 00:58:20 -0500
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070508055820.GA14619@lixom.net>
References: <20070508003642.5964.37001.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508003642.5964.37001.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:36:51AM +0400, Vitaly Bordug wrote:
> 
> Adds support for PowerQuicc on-chip PCMCIA. The driver is implemented as
> of_device, so only arch/powerpc stuff is capable to use it, which now
> implies only mpc885ads reference board.
> 
> To cope with the code that should be hooked inside driver, but is really
> board specific (like set_voltage), global structure mpc8xx_pcmcia_ops
> holds necessary function pointers that are filled in the BSP code.
> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Olof Johansson <olof@lixom.net>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXLSUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXLSUue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLSUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:50:26 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45149 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbXLSUu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:50:26 -0500
Date: Wed, 19 Dec 2007 21:52:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071219205219.GA26957@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 03:10:28PM -0500, linux-os (Dick Johnson) wrote:
> 
> 
> Here is a so-called BUG when trying to insert the following
> module into the kernel (2.6.22.1).
> 
> 

> MODULE_ALIAS("MemDev");
> module_init(startup);
> module_exit(quit);

Just a wild guess. Your init and exit functions uses some generic names.
Have you tried renaming them to usual style like:
memdev_init
memdev_exit

So you have no clashes with existing global symbols.

	Sam

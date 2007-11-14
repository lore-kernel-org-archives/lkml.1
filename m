Return-Path: <linux-kernel-owner+w=401wt.eu-S1764786AbXKNUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764786AbXKNUi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758522AbXKNUip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:38:45 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53578 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbXKNUio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:38:44 -0500
Date: Wed, 14 Nov 2007 21:40:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Marco Costalba <mcostalba@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
Message-ID: <20071114204024.GC10669@uranus.ravnborg.org>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com> <Pine.LNX.4.62.0711051146070.28623@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0711051146070.28623@pademelon.sonytel.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Are you building in a different tree than the source tree? The patch below
> fixed it for me.
> 
> Question: Why don't GENKSYMS and KALLSYMS need the $(srctree) prefix?

They are generated binaries that live in the output directory structure.

> ---
> Subject: kbuild: Add missing srctree prefix for includecheck and versioncheck
> 
> Add missing $(srctree)/ prefix for scripts used by the includecheck and
> versioncheck make targets
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Thanks - applied.

	Sam

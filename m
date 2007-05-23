Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXEWTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXEWTdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEWTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:33:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35862 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEWTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:33:36 -0400
Date: Wed, 23 May 2007 21:34:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] headercheck: add dependency check and improve speed
Message-ID: <20070523193434.GA23924@uranus.ravnborg.org>
References: <20070523181140.GA23425@uranus.ravnborg.org> <20070523184502.GD23425@uranus.ravnborg.org> <1179946939.8303.23.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179946939.8303.23.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 03:02:19PM -0400, David Woodhouse wrote:
> $ make headers_check
> $ sed -i /auxvec.h/d include/asm/Kbuild 
> $ make headers_check
> $ sed -i /auxvec.h/d include/asm-generic/Kbuild.asm
> $ make headers_check
> 
> Why doesn't it recheck <linux/auxvec.h> and fail?

Because asm/auxvec.h gets pulled by asm-generic/Kbuild.asm

	Sam

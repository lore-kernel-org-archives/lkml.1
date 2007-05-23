Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbXEWTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbXEWTkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbXEWTkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:40:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbXEWTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:40:17 -0400
Subject: Re: [PATCH] headercheck: add dependency check and improve speed
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070523193434.GA23924@uranus.ravnborg.org>
References: <20070523181140.GA23425@uranus.ravnborg.org>
	 <20070523184502.GD23425@uranus.ravnborg.org>
	 <1179946939.8303.23.camel@shinybook.infradead.org>
	 <20070523193434.GA23924@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 15:40:25 -0400
Message-Id: <1179949225.8303.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 21:34 +0200, Sam Ravnborg wrote:
> On Wed, May 23, 2007 at 03:02:19PM -0400, David Woodhouse wrote:
> > $ make headers_check
> > $ sed -i /auxvec.h/d include/asm/Kbuild 
> > $ make headers_check
> > $ sed -i /auxvec.h/d include/asm-generic/Kbuild.asm
> > $ make headers_check
> > 
> > Why doesn't it recheck <linux/auxvec.h> and fail?
> 
> Because asm/auxvec.h gets pulled by asm-generic/Kbuild.asm

Not after the 4th command in the above sequence, it doesn't.

-- 
dwmw2


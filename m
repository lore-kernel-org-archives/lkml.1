Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbYFHLUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbYFHLUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbYFHLUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:20:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYFHLUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:20:07 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 12:20:04 +0100
Message-Id: <1212924004.32207.498.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 11:47 +0200, Sam Ravnborg wrote:
> +        $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
> +                BIASMDIR=-bi-$$arch ;\

We still use $(BIASMDIR) as a trigger to install into asm-$(ARCH)/
instead of just to asm/, for 'headers_install_all'. But it's a fairly
bad name now, since it doesn't do what it used to do.

-- 
dwmw2


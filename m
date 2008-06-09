Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbYFIKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbYFIKTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759285AbYFIKT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:19:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbYFIKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:19:25 -0400
Subject: Re: [PATCH 5/6] kbuild: error out early in make headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
In-Reply-To: <1212955658-32168-5-git-send-email-sam@ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <1212955658-32168-5-git-send-email-sam@ravnborg.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 11:19:15 +0100
Message-Id: <1213006756.32207.608.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-08 at 22:07 +0200, Sam Ravnborg wrote:
> Fix the a.out.h case by setting SRCARCH and error
> out early in case of an error.
> The a.out.h case failed with the *_all targets.

I wanted to do the same trick ($(if $(wildcard asm-$(SRCARCH)/a.out.h)))
for exporting linux/a.out.h too -- that should never have been
unexported, and really should be put back before 2.6.26 release (I think
I sent a patch, already).

I suppose we'll have to also export it ifeq ($(SRCARCH),).

-- 
dwmw2


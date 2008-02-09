Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYBIRQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYBIRQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYBIRQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:16:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60562 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbYBIRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:16:06 -0500
Date: Sat, 9 Feb 2008 12:16:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/8] kgdb: COPTIMIZE flag
Message-ID: <20080209171605.GC15568@infradead.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 07:35:10AM -0600, jason.wessel@windriver.com wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> This patch adds in the ability to unoptimize a single kernel module to
> make source stepping more linear and not optimize out variables that
> the developer might like to inspect.  It used with adding
> COPTIMIZE=-O0 to the build line when doing something like a single
> kernel module only build.  Or you could use it to override the default
> optimization level entirely.

This seems a bit unrelated to kgdb, but fine to me in general.  Please
run it past Sam, the kbuild maintainer.


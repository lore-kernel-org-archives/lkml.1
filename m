Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYBIRKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYBIRKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYBIRKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:10:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbYBIRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:10:29 -0500
Date: Sat, 9 Feb 2008 12:10:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/8] pid, kgdb: add pid_max prototype
Message-ID: <20080209171026.GA15568@infradead.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 07:35:08AM -0600, jason.wessel@windriver.com wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> add pid_max prototype - now used by sysctl and kgdb as well.

extern should never be in .c files, so this should be submitted now,
even independent of kgdb.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYAARr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYAARr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYAARrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:47:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52241 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbYAARrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:47:48 -0500
Date: Tue, 1 Jan 2008 17:47:08 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/byteorder.h: clean up for userspace
Message-ID: <20080101174708.GA25089@infradead.org>
References: <200712311312.46450.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712311312.46450.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 01:12:45PM -0500, Mike Frysinger wrote:
> Since asm-x86/byteorder.h is exported to userspace, use __asm__ rather than
> asm in its code.

The correct fix is to not export it to userspace.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXCMFOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXCMFOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXCMFOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:14:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:32871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXCMFOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:14:18 -0400
Date: Mon, 12 Mar 2007 22:14:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanfile: a script to clean up stealth whitespace
Message-Id: <20070312221414.94977b7d.akpm@linux-foundation.org>
In-Reply-To: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org>
References: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 12:16:30 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> This script cleans up various classes of stealth whitespace.  In
> particular, it cleans up:
> 
> - Whitespace (spaces or tabs)before newline;
> - DOS line endings (CR before LF);
> - Space before tab (spaces are deleted or converted to tabs);
> - Empty lines at end of file.

Fair enough.

It'd be nice to have a clean-up-a-patch version of this.  So it does
all these things, except it only changes lines which start with ^+.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbYBMELd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbYBMELd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYBMELZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:11:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37074 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYBMELY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:11:24 -0500
Date: Wed, 13 Feb 2008 04:11:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] drivers/memstick/host/tifm_ms.c breakage
Message-ID: <20080213041123.GT27894@ZenIV.linux.org.uk>
References: <20080213035659.GQ27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213035659.GQ27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:56:59AM +0000, Al Viro wrote:
> readl(sock + ...) that should've been readl(sock->addr + ...)

s/readl(/writel(..., / in the changelog message...

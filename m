Return-Path: <linux-kernel-owner+w=401wt.eu-S965385AbZLHBvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385AbZLHBvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935761AbZLHBvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:51:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50380 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935746AbZLHBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:51:42 -0500
Date: Tue, 8 Dec 2009 01:51:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091208015148.GK14381@ZenIV.linux.org.uk>
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com> <4B1D988E.2000305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D988E.2000305@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:06:38AM +0100, Emese Revfy wrote:

> DEBUG_RODATA catches the unwanted write attempt at runtime whereas
> my patch will catch it at compile time. I think it's better to detect
> an error as early as possible.

Not when the price is readability.  Moreover, you *still* are not
covering the real policy - these suckers should be statically allocated,
not just never modified.

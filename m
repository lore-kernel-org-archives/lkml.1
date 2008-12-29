Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYL2OCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYL2OCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYL2OCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:02:22 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50778 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYL2OCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:02:21 -0500
Date: Mon, 29 Dec 2008 15:03:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
Message-ID: <20081229140356.GB7327@uranus.ravnborg.org>
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230549153-31754-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
> Rather than constantly fixing up size type breakage in userspace headers,
> auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
> appropriate __uXX or __sXX type.

Is this the right thing to do?
uintXX_t belongs to a namespace that the kernel should not use.

So being restrictive here would be better I think.

	Sam

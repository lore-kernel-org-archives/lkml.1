Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZARUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZARUwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZARUwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:52:33 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49599 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZARUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:52:32 -0500
Date: Sun, 18 Jan 2009 21:54:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] kconfig: print all locations when we see a recursive dependency
Message-ID: <20090118205416.GD2978@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org> <1230558803-7168-6-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0812310346430.17013@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812310346430.17013@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 03:55:00AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Mon, 29 Dec 2008, Sam Ravnborg wrote:
> 
> > It is nessesary to know all locations when trying to track
> > a recursive dependency. So print out all locations for each symbol.
> 
> The problem is that this is little more than a better grep, although 
> kconfig knows exactly what went wrong, but this info is scattered all over 
> the stack.
> We could either return more info to print more than just the symbol or 
> maintain more info while traversing the tree. The patch below does the 
> latter. The patch could use some small cleanups, so it's not final yet.

Hi Roman.

Have you had time to look more into this?

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763050AbYD1E7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763050AbYD1E7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYD1E6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:58:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYD1E6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:58:55 -0400
Date: Sun, 27 Apr 2008 21:58:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
Message-ID: <20080427215840.0961be81@laptopd505.fenrus.org>
In-Reply-To: <20080427.174536.62560212.davem@davemloft.net>
References: <20080427.174536.62560212.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 17:45:36 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> I'm trying to stir up interest in solving a problem that seems to pop
> up frequently. :)
> 
> The short story is:
> 
> 1) If you say your driver "depend"s on a subsystem providing a set of
>    interfaces you need, this doesn't work properly if your driver is
>    marked built-in and that subsystem you need is modular for some
>    reason.
> 
> 2) If you say "select" on some subsystem, to try and solve the
>    conflict in #1, that doesn't take care of any dependencies the
>    subsystem may have.  This can also break the build.
> 
> There should be an elegant solution to this problem.  But I don't
> think changing how 'select' or 'depend' works is it.
> 
> 'depend' as it stands now works fine for purely boolean things like
> "this architecture has or wants FOO".  There is no reason to remove
> it or change it's semantics, I think.

how far would "if you DEPENDS on FOO, and FOO is =m, you can only be =m or =n" get us?
or are there hidden traps on this?
(the hard case is if a non-tristate DEPENDS on a tristate, but... that's a trap anyway)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

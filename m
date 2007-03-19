Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXCSMw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXCSMw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933845AbXCSMw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:52:59 -0400
Received: from smtp1.kolej.mff.cuni.cz ([195.113.24.4]:50444 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbXCSMw6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:52:58 -0400
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Mon, 19 Mar 2007 13:32:50 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Ondrej Zajicek <santiago@crfreenet.org>,
       James Simmons <jsimmons@infradead.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/video/s3fb.c: fix a use-before-check
Message-ID: <20070319123250.GA4152@localhost.localdomain>
References: <20070319092552.GP752@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319092552.GP752@stusta.de>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 10:25:52AM +0100, Adrian Bunk wrote:
> NULL checks should be before the first dereference.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@mail.cz, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

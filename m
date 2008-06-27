Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbYF0VDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbYF0VDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYF0VDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:03:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59938 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbYF0VDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:03:12 -0400
Date: Fri, 27 Jun 2008 23:03:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: stable@kernel.org, llipavsky@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move __attribute__((__cold__)) functions back into final .text section
Message-ID: <20080627210359.GB29245@uranus.ravnborg.org>
References: <48590F41.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48590F41.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:36:01PM +0100, Jan Beulich wrote:
> Due to the addition of __attribute__((__cold__)) to a few symbols
> without adjusting the linker scripts, those symbols currently may end
> up outside the [_stext,_etext) range, as they get placed in
> .text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
> outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
> Hence we need to add .text.unlikely (and for future uses of
> __attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.
> 
> Issue observed by Lukas Lipavsky.
> 
> Cc: Lukas Lipavsky <llipavsky@suse.cz>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied.

	Sam

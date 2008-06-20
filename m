Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYFTJGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYFTJGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYFTJGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:06:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:45624 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbYFTJGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:06:22 -0400
Subject: Re: [PATCH] move __attribute__((__cold__)) functions back into
	final .text section
From: Lukas Lipavsky <llipavsky@suse.cz>
To: Jan Beulich <jbeulich@novell.com>
Cc: sam@ravnborg.org, stable@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48590F41.76E4.0078.0@novell.com>
References: <48590F41.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=utf8
Date: Fri, 20 Jun 2008 11:06:17 +0200
Message-Id: <1213952777.9696.3.camel@hex.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich píše v St 18. 06. 2008 v 12:36 +0100:
> Due to the addition of __attribute__((__cold__)) to a few symbols
> without adjusting the linker scripts, those symbols currently may end
> up outside the [_stext,_etext) range, as they get placed in
> .text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
> outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
> Hence we need to add .text.unlikely (and for future uses of
> __attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.
> Cc: Lukas Lipavsky <llipavsky@suse.cz>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Tested-by: Lukas Lipavsky <llipavsky@suse.cz>



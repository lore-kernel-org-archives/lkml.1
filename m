Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYKEQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYKEQhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYKEQhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:37:47 -0500
Received: from mail.suse.de ([195.135.220.2]:35350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYKEQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:37:47 -0500
Date: Wed, 5 Nov 2008 08:33:34 -0800
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Message-ID: <20081105163334.GA8473@suse.de>
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org> <20081105113610.GA6382@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105113610.GA6382@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
> There seem to be archs that cannot easily implement a sensible
> pgprot_noncached() function, so we should merge this patch. UIO doesn't
> compile on these archs right now.

No, we should fix those arches to have that function at least NULLed
out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
not something we really want to do if at all possible.

thanks,

greg k-h

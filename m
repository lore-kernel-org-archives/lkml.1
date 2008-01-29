Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbYA2Fuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbYA2Fuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYA2FuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:50:00 -0500
Received: from ozlabs.org ([203.10.76.45]:53467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbYA2Ft6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:49:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Date: Tue, 29 Jan 2008 16:49:51 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080125071127.GA4860@kroah.com> <200801261550.58337.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801262239550.3222@www.l.google.com>
In-Reply-To: <alpine.LFD.1.00.0801262239550.3222@www.l.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291649.52576.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 17:42:28 Linus Torvalds wrote:
> My problem is that the *driver* already exists (because it's compiled in),
> and has already initialized itself, and has already registered.
>
> Then, initrd tries to load an old module for that driver.

I hate to say it, but this is user error.  And it used to be that for some 
drivers you'd actually end up with two in-kernel if you did that.

But if even *you* don't get this right, it should finally prompt us to fix 
this...

Thanks,
Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYBAK6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYBAK6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYBAK6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:58:36 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:55670 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbYBAK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:58:35 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <47A272D8.7030106@zytor.com>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
	 <1201815920-24669-2-git-send-email-ijc@hellion.org.uk>
	 <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
	 <47A26B2F.8080001@davidnewall.com>  <47A272D8.7030106@zytor.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 10:58:14 +0000
Message-Id: <1201863494.25409.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 17:16 -0800, H. Peter Anvin wrote:
> David Newall wrote:
> > Isn't a crc32 calculation already defined?  Yes; in lib/crc32.c.  One is
> > surely enough.
> 
> As long as it can be included in user-space code we should use that one.

I don't think it can. There is a main function surrounded by #ifdef
UNITTEST which might once have worked but now there is far too much
kernel gunk in there (as you might expect).

If I can work up the enthusiasm I might break out the core algorithm
into a separate file that can be used in both the kernel and userspace.

Ian.

-- 
Ian Campbell
Current Noise: Reverend Bizarre - Cirith Ungol

"Would I turn on the gas if my pal Mugsy were in there?"
   "You might, rabbit, you might!"
		-- Looney Tunes, Bugs and Thugs (1954, Friz Freleng)


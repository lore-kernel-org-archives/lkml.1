Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYCGIYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYCGIYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYCGIXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:23:48 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:25051 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750923AbYCGIXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:23:48 -0500
X-YMail-OSG: ZJFYcpcVM1ltZgcFuzDM4ZRJKR4O8r4byHm6mEqdMHiMazxmh0WTljDehzGgDOY4bf3yFmbvyQ--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 7 Mar 2008 00:23:41 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080307082341.GA8607@puku.stupidest.org>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu> <20080306112212.GA9261@puku.stupidest.org> <20080306113729.GA18403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306113729.GA18403@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:37:29PM +0100, Ingo Molnar wrote:

> while i have no personal use for chroot=, i generally test distros
> that way, yes - and i try to keep them as unmodified as possible.

It's not clear to me how this would work.

If the distro uses an initrd (most do now?) how will this work?  The
chroot will happen inside the initrd which will then break (because
/init won't be there).

> _Everything_ we do on the boot commandline that affects user-space
> can be done in an initrd in theory - but still we have hundreds of
> boot options.

Precendent alone isn't a good reason to do something, a change should
have merit of it's own.


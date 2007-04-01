Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXDAXjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXDAXjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 19:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXDAXjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 19:39:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:58841 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXDAXjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 19:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HeVJtiKgfNYQEyvpQe+1OkWQgZs/KAh3OLbum8/XgLrgEa7GI4av3EwZLE0DoLALuQtM4YnuxFudd91NmzGKzRZm41z1Eg6t33UZ7D/70dmsmjkHlbm/HlyNFyEWR0zDloK2xIPVfxwsfBQiNP2vA2nzhMiVbooz94UNZX8rqSs=
Subject: Re: [PATCH resend] vt: fix potential race in VT_WAITACTIVE handler
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070401124323.GA4040@spock.one.pl>
References: <20070401124323.GA4040@spock.one.pl>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 07:39:07 +0800
Message-Id: <1175470747.7772.14.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 14:43 +0200, Michal Januszewski wrote:
> From: Michal Januszewski <spock@gentoo.org>
> 
> On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0
> if fg_console has already been updated in redraw_screen() but the
> console switch itself hasn't been completed. Fix this by checking
> fg_console in vt_waitactive() with the console sem held.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Antonino Daplas <adaplas@pol.net>

Andrew,

Drop the old version I sent to you.

Tony



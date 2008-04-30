Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbYD3OS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbYD3OS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYD3OSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:18:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50406 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbYD3OSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:18:17 -0400
Date: Wed, 30 Apr 2008 16:18:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Timur Tabi <timur@freescale.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080430141851.GA1218@uranus.ravnborg.org>
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org> <20080429172057.GN5882@ZenIV.linux.org.uk> <20080429180601.GA19652@uranus.ravnborg.org> <48187A2E.8030502@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48187A2E.8030502@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 08:54:54AM -0500, Timur Tabi wrote:
> Sam Ravnborg wrote:
> >> Good grief, folks...
> > 
> > Thanks Al.
> > I've queued up the following patch.
> > 
> > 	Sam
> > 
> > commit c99cc32e0d92f5fdbdd39a7f42cfff869062fff5
> > Author: Sam Ravnborg <sam@uranus.ravnborg.org>
> > Date:   Tue Apr 29 20:02:44 2008 +0200
> > 
> >     kconfig: made check-lxdialog more portable
> >     
> >     OS-X shell did not like 'echo -e' so implement
> >     suggestion from Al Viro to use a more portable construct.
> >     
> >     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> >     Cc: Al Viro <viro@ZenIV.linux.org.uk>
> 
> Just for the record:
> 
> Acked-By: Timur Tabi <timur@freescale.com>
> 
> This works on OS X.  I haven't tested it on Linux, though.
> 
> FYI, there are other issues that break cross-compiling from OS X, but none of
> them are related to /bin/sh.  I'll post patches for those later this week.
Thanks.

	Sam

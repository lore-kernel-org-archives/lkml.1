Return-Path: <linux-kernel-owner+w=401wt.eu-S2992659AbXEBD3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659AbXEBD3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992669AbXEBD3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:29:42 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39657 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992659AbXEBD3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:29:41 -0400
Date: Tue, 1 May 2007 20:31:02 -0700
From: Greg KH <greg@kroah.com>
To: Neil Brown <neilb@suse.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SCSI discover order strangeness [Bug 8412] New:
	CONFIG_MOUSE_PS2 makes RAID detection fail
Message-ID: <20070502033102.GA7890@kroah.com>
References: <200705010918.l419IC8B016596@fire-2.osdl.org> <17975.3196.435174.722895@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17975.3196.435174.722895@notabene.brown>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 07:46:36PM +1000, Neil Brown wrote:
> 
> My first thought was that the new threaded device discovery was
> allowing md init to happen before scsi discovery was complete.  Maybe
> the presence of CONFIG_MOUSE_PS2 makes some bit go faster...
> 
> However 
>   # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> so maybe not...
> 
> Greg (or anyone else reading): you know about this threaded
> discovery.. could it allow some discovery to complete after userspace
> has started, and does CONFIG_SCSI_SCAN_ASYNC affect it?

This kind of threaded discovery is different from the bus-level threaded
probing that I originally proposed a while back, and then later
retracted due to bugs.

So this is just a scsi thing, I know nothing about it.

thanks,

greg k-h

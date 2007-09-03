Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXICIhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXICIhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXICIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:37:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbXICIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:37:36 -0400
Date: Mon, 3 Sep 2007 10:37:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Rob Landley <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Message-ID: <20070903083733.GA31880@one.firstfloor.org>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200709020344.51437.rob@landley.net> <46DA7A4C.6080501@zytor.com> <200709020605.00782.rob@landley.net> <m1d4x0zvri.fsf@ebiederm.dsl.xmission.com> <20070902200010.GS21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902200010.GS21089@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 09:00:10PM +0100, Al Viro wrote:
> On Sun, Sep 02, 2007 at 01:56:33PM -0600, Eric W. Biederman wrote:
> > - I think all that is left is superblock handling and some backward
> >   compatibility magic. (Using the follow_link trick to automatically
> >   mount /proc/sys)
> 
> NAK.  Let's explicitly mount this stuff in init scripts; it won't break
> on older kernels and there's no excuse for that kind of kludges in the
> kernel.

That would probably break near all init scripts out there.

Can't the file system not just be mounted with /proc together?

-Andi

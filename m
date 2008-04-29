Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbYD2Qsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbYD2Qsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYD2Qso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:48:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35312 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYD2Qsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:48:43 -0400
Date: Tue, 29 Apr 2008 17:48:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Timur Tabi <timur@freescale.com>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080429164838.GM5882@ZenIV.linux.org.uk>
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429164501.GA18018@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:45:01PM +0200, Sam Ravnborg wrote:
> > 
> > I read in the latest Linux Journal magazine that someone noticed that even
> > though the kernel scripts say #!/bin/sh, many of them are really bash scripts.
> > This person went through the effort of changing the script to be true 'sh'
> > scripts.  Has that code been merged in?
> 
> I have no patches pending but I may have lost them.
> As I am 100% ignorant about what is bash and what is not bash specialities
> I will more or less be blind when I apply them so I hope they are well
> tested.

*shrug*

As a sanity check, try to run them with ash(1).  Before going into review
of portability.

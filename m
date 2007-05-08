Return-Path: <linux-kernel-owner+w=401wt.eu-S934813AbXEHWZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbXEHWZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934613AbXEHWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:25:42 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:41211 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934456AbXEHWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:25:42 -0400
Date: Tue, 8 May 2007 18:25:40 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
Message-ID: <20070508222540.GG8753@csclub.uwaterloo.ca>
References: <200705081903.l48J3AOw010373@hera.kernel.org> <20070508124301.17975a4f.randy.dunlap@oracle.com> <4640E971.9050400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4640E971.9050400@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 05:19:45PM -0400, Jeff Garzik wrote:
> >>+Do not unnecessarily use braces where a single statement will do.
> >>+
> >>+if (condition)
> >>+	action();
> >>+
> >>+This does not apply if one branch of a conditional statement is a single
> >>+statement. Use braces in both branches.
> >>+
> >>+if (condition) {
> >>+	do_this();
> >>+	do_that();
> >>+} else {
> >>+	otherwise();
> >>+}
> 
> If anyone tries to add braces to my code's 'else' statements where they 
> are not required, that patch will get NAK'd in a heartbeat.

Oh isn't coding style fun.  I personally hate code that doesn't ALWAYS
have the braces everywhere since it makes adding a print statement
or other debuging to the condition such a pain since you then have to
add braces to the condition to avoid breaking the code just to insert
a print statement.  It is one of the few things I disagree with in the
linux kernel coding style.

--
Len Sorensen

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXJWQ0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXJWQ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJWQ0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:26:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38054 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXJWQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:26:35 -0400
Date: Tue, 23 Oct 2007 09:23:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-ID: <20071023092333.39982483@laptopd505.fenrus.org>
In-Reply-To: <20071023150429.GK4003@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com>
	<20071022114001.40470c15.akpm@linux-foundation.org>
	<20071023150429.GK4003@csclub.uwaterloo.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 11:04:29 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Mon, Oct 22, 2007 at 11:40:01AM -0700, Andrew Morton wrote:
> > - Here:
> > 
> > +		if (0 == memcmp(&heci_wd_guid,
> > 
> >   we boringly prefer "if (foo == 0)" rather than "if (0 == foo)".
> > (lots of places).
> 
> But 0 == blah is safer.  If you accidentally do 0 = blah the compiler
> will tell you. 

gcc will tell you in the other direction just as well.

and people read from left to right (at least in english) so coding in
that direction is generally preferred in the Linux kernel as well.

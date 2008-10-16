Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYJPJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYJPJOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYJPJNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:13:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34209 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYJPJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:13:52 -0400
Date: Thu, 16 Oct 2008 11:13:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Message-ID: <20081016091351.GC15439@atrey.karlin.mff.cuni.cz>
References: <200810142254.07024.rjw@sisk.pl> <20081015085809.GA1061@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015085809.GA1061@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 14, 2008 at 10:54:06PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
> > 
> > HP xw4600 Workstation is known to require the "old" (ie. compatible
> > with ACPI 1.0) suspend code ordering, so blacklist it for this
> > purpose.
> 
> This doesn't seem to be scaling especially well. The xw4600 is a new 
> machine, so if it needs the "old" code ordering then that's a strong 
> indication that we're doing something wrong. I think trying to work out 
> what would be more useful than just adding it to a blacklist.

HP seems pretty responsive in this case, you are welcome to work with
them...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

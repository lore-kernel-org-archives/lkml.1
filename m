Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXILNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXILNNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXILNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:13:07 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54061 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXILNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:13:06 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 12 Sep 2007 09:11:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Newall <david@davidnewall.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
In-Reply-To: <46E7DEF8.50201@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
 <46E7DEF8.50201@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, David Newall wrote:

> Robert P. J. Day wrote:
> >   while killing some time between compiles and ridding the
> > kernel-parameters.txt file of out-of-date or incorrect cruft, it
> > occurs to me that that file is borderline valueless since it
> > apparently tries to document every possible boot-time parameter,
> > including those associated with individual modules.  that's just
> > silly.
>
> "Silly" is such a negative word.  I think it's aspirational.  It
> probably can't be achieved, but that's no reason to give up, nor to
> remove existing text.

if the goal is to simply put all of the basic boot-time kernel parms
along with the module-specific ones into a single file, sorted in
alphabetical order, then i contend that this is, in fact, "silly".
the end result would be a somewhat chaotic mess since i think it's
clear that those "basic" kernel parms (as i call them) are
qualitatively different from the module-specific ones, and should be
segregated as such.

now, if they're still going to go into a single file, it *would* make
sense to put the basic ones at the top and, following that, the
module-specific ones, one module at a time.  *that* would make perfect
sense.  but to mix them as they are now doesn't.

rday

p.s.  by "basic", i mean those boot-time parms defined by either
"__setup()" or "early_param()".  which means that module writers
should, as much as possible, stop using those macros to define
command-line parameters for their modules.  that would go a long way
to restoring some order, and allowing for some decent and readable
documentation.

--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S969900AbXILOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969900AbXILOqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966613AbXILOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:46:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33351 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966280AbXILOqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:46:44 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 12 Sep 2007 10:44:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Rogan Dawes <lists@dawes.za.net>
cc: David Newall <david@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
In-Reply-To: <46E7F816.9080806@dawes.za.net>
Message-ID: <Pine.LNX.4.64.0709121034450.25084@localhost.localdomain>
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
 <46E7DEF8.50201@davidnewall.com> <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
 <46E7F816.9080806@dawes.za.net>
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

On Wed, 12 Sep 2007, Rogan Dawes wrote:

> Robert P. J. Day wrote:
> > p.s.  by "basic", i mean those boot-time parms defined by either
> > "__setup()" or "early_param()".  which means that module writers
> > should, as much as possible, stop using those macros to define
> > command-line parameters for their modules.  that would go a long
> > way to restoring some order, and allowing for some decent and
> > readable documentation.
>
> Are you forgetting that modules can often be compiled into the
> bzImage, too, making them genuine boot-time params?

<sarcasm>
really?  no way.  get outta town.
</sarcasm>

  sorry, but there was no way i could resist that.  :-)  *of course* i
realize that.  *all* of those things (__setup, early_param, actual
module params) are potential entries on the kernel line at boot time,
depending on your particular configuration.

  all i'm suggesting is that there is an obvious distinction between
those that are defined using __setup() or early_param(), and those
that are actual module parameters.  and that it would make more sense
to keep them separate, even if only separating them within the same
text file.

  in the end, there should be a nice, *short* reference for what i
like to call "basic" kernel parms (defined by __setup() or
early_param()), while anyone who wants to learn about any
module-specific parms should then have to go look up the info for that
given module, that's all.

  as a trivial starting point, this would involve nothing more than
shifting current content around in kernel-parameters.txt, putting the
basic stuff at the top, and the module-specific stuff after that.
heck, that would even give module authors the chance to add a line or
two of module description if they wanted.  how does life get any
better than that?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

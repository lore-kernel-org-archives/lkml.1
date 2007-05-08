Return-Path: <linux-kernel-owner+w=401wt.eu-S934941AbXEHQTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941AbXEHQTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934929AbXEHQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:19:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36773 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442AbXEHQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:19:40 -0400
X-Originating-Ip: 99.246.112.70
Date: Tue, 8 May 2007 12:19:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <Pine.LNX.4.61.0705081117051.17280@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705081215220.8750@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <1178612519.3042.294.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
 <Pine.LNX.4.61.0705081117051.17280@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jan Engelhardt wrote:

>
> On May 8 2007 04:41, Robert P. J. Day wrote:
> >
> >  in my opinion, the config option "EMBEDDED" is just plain silly.  as
> >i mentioned earlier, there may be other reasons that people want to
> >de-activate normally selected features rather than just for strictly
> >embedded systems.
>
> Did not you want to make a patch row that expresses all your ideas, aka
>   CONFIG_EXPERT
>   CONFIG_ASKFORDETAILS (former CONFIG_EMBEDDED, e.g. "place in memory where
> kernel is loaded")
>   CONFIG_OBSOLETE
>   CONFIG_DEPRECATED
> etc.? :)

i hadn't actually considered *that* possibility, but the idea is sort
of what i had in mind -- a clear, top-level setting that, in one swell
foop, will change what's available throughout the tree.  i think
that's the most intuitively clear way to do it.

rday

p.s.  mostly, i just don't think labelling that selection with the
word "EMBEDDED" makes a lot of sense.  who's to say that any given
feature should be de-selectable only on an embedded system?
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

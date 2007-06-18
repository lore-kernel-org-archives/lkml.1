Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXFRNLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXFRNLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbXFRNLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:11:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59395 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761339AbXFRNLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:11:01 -0400
Date: Mon, 18 Jun 2007 15:11:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gerrit Huizenga <gh@us.ibm.com>
Cc: holzheu@linux.vnet.ibm.com, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070618131157.GA23229@uranus.ravnborg.org>
References: <1181817533.10064.18.camel@localhost.localdomain> <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:42:15AM -0700, Gerrit Huizenga wrote:
> 
> Andrew mentioned a mechanism for adding a subsystem tag or other tag
> which helps disambiguate the message, either in the message file or in
> the end user documentation (e.g. the Message Pedia/mPedia that the Japanese
> have already created with ~350 messages, and a total of ~700 targetted
> by the end of the year).
> 
> That tag could be appended to the beginning of the printk, to the end of
> the printk, or even in a formatted comment at the end of the printk that
> the tool could extract.

The best way to maintain such a subsystem tag most be supported by
kbuild. So say we have the subsystem "scsi" then we can set this subsystem
tag in drivers/scsi/Makefile and let drivers/scsi/arm/Makefile inherit
this vaule doing nothing.

Addign the subsystem tag to the printk could than be done using the
C preprocessor and we are all fine.

If we go by the kernel-doc way to document kernel messages (the few that
actually needs additional explanation) then we need to teach kernel-doc
to collect the same subsystem tag but that should be doable.

	Sam

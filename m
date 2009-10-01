Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZJAKfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZJAKfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZJAKfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:35:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33007 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756181AbZJAKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:35:32 -0400
Date: Thu, 1 Oct 2009 11:36:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree boot crash] Re: [GIT PATCH] TTY patches for
 2.6.31-git
Message-ID: <20091001113610.0915de7d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091001082115.GA12200@elte.hu>
References: <20090919213345.GB7668@kroah.com>
	<20090930100902.GA29872@elte.hu>
	<20090930111726.618af641@lxorguk.ukuu.org.uk>
	<20091001082115.GA12200@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, removing the serial console boot line portion still causes a 
> spontaneous reboot. Same for removing /bin/setserial and removing 
> /dev/ttyS0 and /dev/ttyS1.
> 
> That would exclude all possible uses of the codepath affected by that 
> commit, right?

Who knows what the early Red Hat user space does. Booting with
init=/bin/sh might be informative just as a double check.

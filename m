Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZHCSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZHCSa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZHCSaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:30:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48264 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbZHCSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:30:25 -0400
Date: Mon, 3 Aug 2009 19:31:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Othman, Ossama" <ossama.othman@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Message-ID: <20090803193131.7b25e6c1@lxorguk.ukuu.org.uk>
In-Reply-To: <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
	<20090801073053.GA30389@merkur.ravnborg.org>
	<A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This guideline doesn't appear in Documentation/CodingStyle.  Should it?

Possibly - the thing is there are several cases where its used
deliberately the other way around.

>> >> +	struct memrar_allocator *allocator = 0;
> >
> >It is recommended to separate definition,
> >and assignment.
> >So this should look like this:
> >
> >	struct memrar_allocator *allocator;
> >
> >	allocator = 0;
> 
> Okay, I'll fix that, too.  Should this go into Documentation/CodingStyle, too?

This is nonsense to put it politely. It's a pointer so it should be =
NULL but the formatting is just fine. It's not in the coding style
because its bunkum 8)

Alan

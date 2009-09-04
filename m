Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZIDOqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZIDOqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZIDOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:46:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:8644 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756896AbZIDOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,333,1249282800"; 
   d="scan'208";a="723910087"
Date: Fri, 4 Sep 2009 16:46:34 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu
Subject: Re: WARNINGs in usb-serial.c
Message-ID: <20090904164634.5575e09b@linux.intel.com>
In-Reply-To: <20090903214304.GA23020@suse.de>
References: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu>
	<20090903183637.GA5140@suse.de>
	<200909032324.01311.rjw@sisk.pl>
	<20090903214304.GA23020@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you have a pointer to the patches, please?  I need it for the
> > regression list.

Not a regression alas.. always been buggy and the warnings go back
forever too

> They were posted on the linux-usb mailing list, I'm still fighting my
> patch queue to get them into my tree soon.

They fix the refcounting properly - I need to review them for Alan when
next week but they look robust. All the old uglies go away with the
move to full refcounting everywhere as the nasty cases when an ldisc
echoes chars into a port as it closed just come out in the refcounting.

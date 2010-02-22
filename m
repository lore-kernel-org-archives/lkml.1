Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0BVSPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:15:07 -0500
Received: from senator.holtmann.net ([87.106.208.187]:47608 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0BVSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:15:04 -0500
Subject: Re: [PATCH 1/2] Document the rfkill sysfs ABI
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, florian@mickler.org,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1266851877.23882.67.camel@jlt3.sipsolutions.net>
References: <1266702045-6062-1-git-send-email-florian@mickler.org>
	 <1266702045-6062-2-git-send-email-florian@mickler.org>
	 <1266704345.32739.0.camel@jlt3.sipsolutions.net>
	 <1266746930.18491.1.camel@violet>  <20100222150006.GA2988@tuxdriver.com>
	 <1266851877.23882.67.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 19:16:30 +0100
Message-ID: <1266862590.18491.37.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> > > > > This moves sysfs ABI info from Documentation/rfkill.txt to the
> > > > > ABI subfolder and reformats it.
> > > > > 
> > > > > Signed-off-by: Florian Mickler <florian@mickler.org>
> > > > 
> > > > This is fine with me.
> > > 
> > > we have to be careful here. Some of these sysfs details needs to be
> > > deprecated and removed. Applications should use /dev/rfkill
> > actually.
> > 
> > Maybe all of it should be in "obsolete"?
> 
> Maybe, maybe not. Some people hate /dev/rfkill because it means they
> need to use a programming language (rather than shell scripts), and I
> don't care enough to fight with them.
> 
> For all I care, it can be at the current status quo forever.

I am fine with having these information in sysfs, but then they should
be useful. So we should expose the hard and soft block states and not
some magic madeup state. Also the claim file has to go away.

And not that the rfkill utility is perfect for scripting, but
whatever ;)

Florian, feel free to export the details from /dev/rfkill as proper
sysfs attributes and make them ABI, then we can talk.

Regards

Marcel



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbXKASuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbXKASuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXKASu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:50:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbXKASu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:50:28 -0400
Date: Thu, 1 Nov 2007 11:45:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, hjlipp@web.de, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] usb_gigaset: suspend support [v2]
Message-Id: <20071101114537.0091c8d1.akpm@linux-foundation.org>
In-Reply-To: <472A18D7.7020703@imap.cc>
References: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>
	<20071029214131.70EABFC043@xenon.ts.pxnet.com>
	<20071030140124.984aba58.akpm@linux-foundation.org>
	<472A18D7.7020703@imap.cc>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 19:20:07 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> >> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
> >> +{
> >> +	struct cardstate *cs;
> >> +	struct usb_cardstate *ucs;
> >> +
> >> +	if ((cs = usb_get_intfdata(intf)) == NULL ||
> >> +	    (ucs = cs->hw.usb) == NULL) {
> >> +		err("%s: no cardstate", __func__);
> >> +		return -EFAULT;
> >> +	}
> > 
> > Is the above reeeeeely needed?  I bet it never happens.
> 
> I'm a great believer in defensive programming. :-)
> 
> Anyway, to be sure these checks aren't needed, I would need the
> assurance that the suspend and resume methods are serialized with
> the probe and disconnect methods. Are they?

dunno it beats me.  Not to my knowledge.  Perhaps Greg and Rafael would know?

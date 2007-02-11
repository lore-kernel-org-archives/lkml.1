Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXBKNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXBKNGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBKNGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:06:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXBKNGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:06:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 14:04:13 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171147026.19894.16.camel@nigel.suspend2.net> <20070211064636.GA12171@1wt.eu>
In-Reply-To: <20070211064636.GA12171@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111404.14517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 07:46, Willy Tarreau wrote:
[--snip--]

> What I really think would be a clean solution would be sort of
> a capability. Either the driver *is* suspend/resume-capable, and
> the system can be suspended. Or it is not, and the system must
> refuse to suspend. It should not be a problem to proceed like
> this because drivers which will not support suspend will mainly
> be those which will not have to. And if a user occasionnaly
> complains that one driver does not support it, at least you will
> have a good argument against its author to implement suspend.

I agree, but the suspend/resume safeness has to be somehow indicated by
the driver.  We could add a flag for that, but it would require us to modify
lots of existing drivers (unless there's something obvious I don't see).
However, the driver can effectively say "I'm not suspend/resume-safe" by
returning an error from .suspend(), in which case the system will automatically
refuse to suspend.

Greetings,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYCWVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYCWVRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 17:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYCWVRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 17:17:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYCWVRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 17:17:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 2)
Date: Sun, 23 Mar 2008 22:16:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200803210101.04706.rjw@sisk.pl> <20080321081536.GA25009@uranus.ravnborg.org>
In-Reply-To: <20080321081536.GA25009@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232216.44627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Sam Ravnborg wrote:
> Hi Rafael.

Hi Sam,

> Is it possible to extend this in some way so we avoid the
> #ifdef stuff in the drivers?

Well, I'd love to do something like this.

> We could introduce a few special sections that we discard if
> PM is not in use.
> We have a reliable build time infrastructure to detect
> inconsistencies if needed.
> 
> Something like:
> #define __suspend     __section(.suspend.text)
> #define __suspenddata __section(.suspend.data)
> 
> #define __hibernate     __section(.hibernate.text)
> #define __hibernatedata __section(.hibernate.data)
> 
> A few more tricks will be needed when we assign the functon pointers.
> We have __devexit_p(*) and we may use something similar.

Unfortunately, I have a little experience with linkers and I don't think I'll
be able to do anything like this in a reasonable time without any help.

Thanks,
Rafael

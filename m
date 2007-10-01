Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXJATut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXJATut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJATum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:50:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXJATul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:50:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Santiago Garcia Mantinan <manty@manty.net>
Subject: Re: [PATCH] (repost) Fix SMP poweroff hangs
Date: Mon, 1 Oct 2007 22:05:13 +0200
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
References: <46FC20B7.4000606@rtr.ca> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net>
In-Reply-To: <20070930175446.GA2472@pul.manty.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012205.14303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 September 2007 19:54, Santiago Garcia Mantinan wrote:
> > I'd say your problem is more of a distro issue,
> > in that the method you are using to shutdown
> > is not actually requesting "poweroff".
> 
> > That last mess above ("System halted.") comes from kernel_halt(),
> > rather than the expected message ("Power down.") from kernel_power_off().
> 
> > So, try using the "poweroff" command instead of "halt",
> > or try using "halt -p".  If neither of those work,
> 
> Well it works ok with 2.6.22 powering off and saying so right before
> powering off, with some references to ACPI. On 2.6.23-rc8 however it doesn't
> seem to get that far.

There was a bug in 2.6.23-rc8 that caused this to happen.

It's been fixed in the later -git kernels
(commits 2f3f22269bdf702311342c5d106dfdd7347d1c3e,
853298bc03ef65e3eb392f5d61265605214ee8fb).

Greetings,
Rafael

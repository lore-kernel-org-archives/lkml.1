Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbYBZQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbYBZQFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYBZQEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:04:51 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:38266 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbYBZQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:04:50 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: problem with starting 2.6.25-rc1 and latest git
Date: Tue, 26 Feb 2008 17:04:46 +0100
User-Agent: KMail/1.9.7
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200802132316.03155.m.kozlowski@tuxland.pl> <20080218142832.3a092dd5@hyperion.delvare> <20080226130254.5668d330@hyperion.delvare>
In-Reply-To: <20080226130254.5668d330@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261704.46848.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Mon, 18 Feb 2008 14:28:32 +0100, Jean Delvare wrote:
> > On Thu, 14 Feb 2008 00:27:34 +0100, Mariusz Kozlowski wrote:
> > > Of course there is a typo in the subject :)
> > > 
> > > 2.5.25-rc1 -> 2.6.25-rc1
> > > 
> > > > Hello,
> > > > 
> > > > 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> > > > Linux boots but with huge delay due to some issue with loading usb modules.
> > > > Udev complains:
> > > > 
> > > > 'Could not lock modprobe uhci_hcd'
> > > > 'Could not lock modprobe yenta_socket'
> > > > 'Unknown symbol usb_*'
> > > > 'Gave up waiting for init of module usbcore'
> > > > (...)
> > 
> > Have you tried upgrading to rc2? I used to have the same problem you
> > reported, but I was unable to reproduce it since I upgraded to rc2.
> 
> I take this back. It happened to me again today, while I am now running
> rc3.

I can reproduce this here on rc3 as well. Weird - on git tree before
rc3 was released this didn't happen. rc2 and rc1 are broken. I also
don't know why nobody else see this but us :) And not sure how
to debug it some more or provide more accurate information.

	Mariusz

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYJDKJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYJDKJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYJDKJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:09:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYJDKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:09:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Date: Sat, 4 Oct 2008 12:13:21 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200810032351.46869.rjw@sisk.pl> <20081004002724.47fab174@lxorguk.ukuu.org.uk>
In-Reply-To: <20081004002724.47fab174@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810041213.22249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 of October 2008, Alan Cox wrote:
> > in the final phase of hibernation.  In particular, some SATA drivers
> > are going to use it for blacklisting systems in which the disks
> > should not be spun down during the last phase of hibernation (the
> > BIOS will do that anyway).
> 
> If you added the PCI ids for the controller to your tables you could
> implement this series once instead of in multiple drivers

Hm, I'm not sure what you mean exactly, but the point is to blacklist the
on-board controllers only and a devfn of the controller is needed for that,
or a part of it (like the slot number I'm using).  Could that be done above
the driver level?

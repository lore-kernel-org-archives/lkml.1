Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbYJDKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbYJDKJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYJDKJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:09:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYJDKJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:09:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Date: Sat, 4 Oct 2008 12:14:08 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200810032351.46869.rjw@sisk.pl> <48E71514.90505@gmail.com>
In-Reply-To: <48E71514.90505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810041214.09680.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 of October 2008, Tejun Heo wrote:
> Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Hibernation: Introduce system_entering_hibernation
> > 
> > Introduce boolean function system_entering_hibernation() returning
> > 'true' during the last phase of hibernation, in which devices are
> > being put into low power states and the sleep state (for example,
> > ACPI S4) is finally entered.
> > 
> > Some device drivers need such a function to check if the system is
> > in the final phase of hibernation.  In particular, some SATA drivers
> > are going to use it for blacklisting systems in which the disks
> > should not be spun down during the last phase of hibernation (the
> > BIOS will do that anyway).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> applied 1-6 to tj-upstream
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git tj-upstream
>   http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=shortlog;h=tj-upstream

Thanks a lot,
Rafael

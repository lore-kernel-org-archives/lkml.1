Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYJALcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYJALcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYJALcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:32:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57066 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbYJALcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:32:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce new system state for the last phase of hibernation
Date: Wed, 1 Oct 2008 13:36:04 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808290002.55026.rjw@sisk.pl> <200809300010.39000.rjw@sisk.pl> <48E2EF61.8000104@gmail.com>
In-Reply-To: <48E2EF61.8000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011336.05173.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 1 of October 2008, Tejun Heo wrote:
> Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Hibernation: Introduce new system state for the last phase of hibernation
> > 
> > Replace unused SYSTEM_SUSPEND_DISK with a new system_state value
> > SYSTEM_HIBERNATE_ENTER that can be used by device drivers to check if
> > the system is in the last phase of hibernation.
> > 
> > In particular, some SATA drivers are going to use it for blacklisting
> > systems in which the disks should not be spun down during the last
> > phase of hibernation (the BIOS will do that anyway).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Rafael, may I push this through libata-dev?

Sure, please go ahead.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYHKUhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYHKUhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYHKUhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:37:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55857 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYHKUhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:37:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
Subject: Re: Suspend issues on 2.6.27-rc2 (was: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374)
Date: Mon, 11 Aug 2008 22:39:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20080731210507.GA6094@denkbrett.schottelius.org> <200808071852.11080.rjw@sisk.pl> <20080811180416.GA22969@denkbrett.schottelius.org>
In-Reply-To: <20080811180416.GA22969@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808112239.29292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of August 2008, Nico Schottelius wrote:
> Rafael J. Wysocki [Thu, Aug 07, 2008 at 06:52:10PM +0200]:
> > > The problem continues to exist:
> > > 
> > > I tested it on vanilla 2.6.27-rc2: Same problem, system does not wake up.
> > > 
> > > Did not test the proposed patch, because it did not restore the console
> > > in any tested case yet, though it at least wakes the system up.
> > 
> > What graphics adapter is there in your box?
> 
> x1400, using radeonhd (also from git)
> 
> It's a T60 lenovo thinkpad.

There also are models with Intel graphics, I think.

Anyway, the problem is related to either the graphics driver, or ACPI.

Please verify if any ACPI-related settings haven't changed in your .config
between the good kernel and the failing one.

Thanks,
Rafael

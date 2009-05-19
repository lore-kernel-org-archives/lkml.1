Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZESM7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZESM7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZESM67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:58:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58371 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZESM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:58:58 -0400
Date: Tue, 19 May 2009 13:58:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Mario Limonciello <mario_limonciello@dell.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
	suspend
Message-ID: <20090519125853.GA12483@srcf.ucam.org>
References: <4A11C126.1000704@dell.com> <1242710064.3147.4.camel@localhost.localdomain> <20090519090610.GA29967@srcf.ucam.org> <200905191447.34000.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905191447.34000.oliver@neukum.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 02:47:33PM +0200, Oliver Neukum wrote:
> Am Dienstag, 19. Mai 2009 11:06:12 schrieb Matthew Garrett:
> > On Mon, May 18, 2009 at 10:14:24PM -0700, Marcel Holtmann wrote:
> > > Hi Matthew,
> > >
> > > > Ok. I don't think the right way to implement this is forcing
> > > > dell-laptop to simulate an unplug. The HCI driver should be responsible
> > > > for saving and restoring state of the device in its suspend/resume
> > > > method.
> > >
> > > what do you expect the generic USB driver to do? I don't see anything we
> > > can do about it, if the device gets removed from underneath us.
> >
> > If the device is getting removed from underneath you, why isn't hid2hci
> > being run again when it reappears as the hid device?
> 
> udev triggers exactly that.

It doesn't seem to for Mario, otherwise this patch wouldn't change 
anything.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

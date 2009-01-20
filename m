Return-Path: <linux-kernel-owner+w=401wt.eu-S1762376AbZATSkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376AbZATSkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbZATSkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:40:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:34628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbZATSkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:40:18 -0500
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
From: Holger Macht <hmacht@suse.de>
Reply-To: hmacht@suse.de
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
In-Reply-To: <20090120124711.GA1920@elf.ucw.cz>
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl>
	 <20090119221508.GA2576@elf.ucw.cz>
	 <20090120000305.7895eff9@lxorguk.ukuu.org.uk>
	 <20090120124711.GA1920@elf.ucw.cz>
Content-Type: text/plain
Organization: SUSE Linux Products GmbH
Date: Tue, 20 Jan 2009 19:39:19 +0100
Message-Id: <1232476759.5286.6.camel@homac.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 20.01.2009, 13:47 +0100 schrieb Pavel Machek:
> On Tue 2009-01-20 00:03:05, Alan Cox wrote:
> > > I guess I'm confused. I tried:
> > 
> > You want CONFIG_IDE = n, CONFIG_ATA_SFF = y, CONFIG_ATA_PIIX = y
> 
> Thanks.
> 
> With those options, cdrom moved from hda to sr0, and is correctly
> unregistered when undocking. Unfortunately, it is not correctly
> re-registered when I insert machine back into the dock :-(... so
> something is still not right in docking area.

Does this work when you try without the dock station, just removing and
inserting the cdrom?

Regards,
	Holger


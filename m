Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZESMrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZESMrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZESMrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:47:14 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:59727 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZESMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:47:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Tue, 19 May 2009 14:47:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Mario Limonciello <mario_limonciello@dell.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4A11C126.1000704@dell.com> <1242710064.3147.4.camel@localhost.localdomain> <20090519090610.GA29967@srcf.ucam.org>
In-Reply-To: <20090519090610.GA29967@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191447.34000.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Mai 2009 11:06:12 schrieb Matthew Garrett:
> On Mon, May 18, 2009 at 10:14:24PM -0700, Marcel Holtmann wrote:
> > Hi Matthew,
> >
> > > Ok. I don't think the right way to implement this is forcing
> > > dell-laptop to simulate an unplug. The HCI driver should be responsible
> > > for saving and restoring state of the device in its suspend/resume
> > > method.
> >
> > what do you expect the generic USB driver to do? I don't see anything we
> > can do about it, if the device gets removed from underneath us.
>
> If the device is getting removed from underneath you, why isn't hid2hci
> being run again when it reappears as the hid device?

udev triggers exactly that.

	Regards
		Oliver


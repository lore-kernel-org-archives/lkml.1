Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZESHgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZESHgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZESHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:36:36 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55953 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZESHgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:36:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Tue, 19 May 2009 09:36:55 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Mario Limonciello <mario_limonciello@dell.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4A11C126.1000704@dell.com> <200905190827.52541.oliver@neukum.org> <1242715512.3147.6.camel@localhost.localdomain>
In-Reply-To: <1242715512.3147.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905190936.55968.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Mai 2009 08:45:12 schrieb Marcel Holtmann:
> Hi Oliver,

> > > what do you expect the generic USB driver to do? I don't see anything
> > > we can do about it, if the device gets removed from underneath us.
> >
> > In order to do this we'd have to put hid2hci into usbcore and maintain
> > a list of devices it should operate on.
>
> you know that hid2hci is a user space utility.

Yes. I wanted to say that we'd have to port it into kernel space.
I don't think it would be worth the effort. Sorry for being unclear.

	Regards
		Oliver


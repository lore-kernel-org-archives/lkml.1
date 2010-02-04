Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab0BDL0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:26:32 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:33589 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab0BDL0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:26:31 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Paul Rolland <rol@as2917.net>
Subject: Re: usbserial speed limitations ?
Date: Thu, 4 Feb 2010 12:26:21 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20100204095855.10993d1a@tux.DEF.witbe.net>
In-Reply-To: <20100204095855.10993d1a@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041226.21379.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Februar 2010 09:58:55 schrieb Paul Rolland:
> "Maximum connection speed is limited by the current generic usbserial
> driver to approximately less than 500kbps."
> 
> Is there really such a speed limitation in the usbserial module/driver ?
> This modem is HSPA+, which should allow a theorical maximum downspeed of
> 20MBps, not 500kbps...

In the generic usbserial driver this speed limit indeed exists.
But you are not supposed to use it with that kind of device.
Most likely the correct driver would be either option or sierra.
Please post lsusb -v for your device.

	Regards
		Oliver

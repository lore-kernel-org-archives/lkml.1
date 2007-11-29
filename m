Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbXK2IPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbXK2IPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXK2IPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:15:21 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:33556 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbXK2IPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:15:19 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Thu, 29 Nov 2007 09:14:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711290844.39428.oliver@neukum.org> <20071129000149.7569eab1.zaitcev@redhat.com>
In-Reply-To: <20071129000149.7569eab1.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711290914.48050.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2007 09:01:49 schrieb Pete Zaitcev:
> On Thu, 29 Nov 2007 08:44:38 +0100, Oliver Neukum <oliver@neukum.org> wrote:
> > 3. Make sure usbcore doesn't probe the devices in the wrong mode with the
> > option driver
>
> This fixes duplication. And to take it further, why don't we turn this
> idea around and let usb-storage fail to attach with some "ignore" quirk?
> I suspect that someone put the initializer into usb-storage in order
> to let the generic usb serial to work, but this simply was a bad idea.

Yes, you are right. That's the correct approach.

	Regards
		Oliver


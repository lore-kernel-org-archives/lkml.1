Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZCZMGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZCZMGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZCZMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:06:23 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:48683 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZCZMGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:06:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Date: Thu, 26 Mar 2009 13:11:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
References: <20090310112307.GD1337@ucw.cz> <20090319225011.GB6314@elf.ucw.cz> <20090326095856.GA22641@elf.ucw.cz>
In-Reply-To: <20090326095856.GA22641@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903261311.03513.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 26 März 2009 10:58:56 schrieb Pavel Machek:

> > Well, I took btusb.c from 2.6.28 and that fixed the issue; so we know
> > the regression is in btusb.c file between 28 and 29-rc7. If you have
> > specific version of btusb.c you want me to test, please mail it to me.
>
> This smaller patch (partial revert of btusb.c to 2.6.28 state) seems
> to help, too....

Could you test whether reversing the changes to btusb_probe() alone
helps?

	Regards
		Oliver


Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXCELia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXCELia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933188AbXCELia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:38:30 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:60723 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074AbXCELi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:38:29 -0500
Subject: Re: 2.6.21-rc2: bluetooth hardlocks [regression from -rc1]
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070302100427.GA2293@elf.ucw.cz>
References: <20070302100427.GA2293@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 13:38:29 +0100
Message-Id: <1173098310.6638.15.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> As soon as I try to start bluetooth connection (gprs over nokia 6230)
> on thinkpad x60 (internal bluetooth dongle, connected over usb),
> machine hangs. It worked okay in -rc1 (modulo suspend issues).

this might be the same issue that Mark Lord reported recently. It seems
that the device_move() function has some kind of problem. Can you please
check what happens if you remove the following commit:

[Bluetooth] Make use of device_move() for RFCOMM TTY devices

Regards

Marcel



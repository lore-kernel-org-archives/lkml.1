Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZEDR3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZEDR3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZEDR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:29:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55307 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZEDR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:29:14 -0400
Subject: Re: btusb auto suspend
From: Marcel Holtmann <marcel@holtmann.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1241433271.7620.4748.camel@twins>
References: <1241433271.7620.4748.camel@twins>
Content-Type: text/plain
Date: Mon, 04 May 2009 10:29:02 -0700
Message-Id: <1241458142.2903.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> What is the current status of btusb auto suspend? btusb not having this
> feature basically renders BT useless on mobile devices.
> 
> I found some rfc patches and discussion over on linux-pm/-usb but
> couldn't find a clear consensus.

I think none of the patches apply anymore. So they have to be redone
against the latest -rc4 kernel or bluetooth-testing.git.

We had some battles with broken Bluetooth hardware that requires to keep
the interrupt and bulk URBs in fly, because otherwise the firmware
inside the controller can't sync them up and times out. These are all
fixed now, but nobody has looked at the auto suspend stuff. Feel free to
pick Oliver's patches up and send them for review. If you do so, please
use linux-bluetooth@vger.kernel.org since I do miss posting on LKML from
time to time.

Regards

Marcel



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYBMKbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYBMKbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYBMKb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:31:29 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57524 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBMKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:31:29 -0500
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla
	#9027)
From: Marcel Holtmann <marcel@holtmann.org>
To: SDiZ <sdiz@sdiz.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47B266AE.3040908@sdiz.net>
References: <47B266AE.3040908@sdiz.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 11:31:32 +0100
Message-Id: <1202898692.7664.369.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This patch fix bugzilla #9027.
> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
> connection handle 92" message"
> 
> see http://bugzilla.kernel.org/show_bug.cgi?id=9027

when we get the content of /proc/bus/usb/devices for this one. Do you
have the manufacturer name of it or at least an idea which kind of
device this is. Check "hciconfig hci0 version".

Dave, I don't think this is a broken dongle. I think he hits the case of
eSCO versus SCO connection (the fallback to SCO case). I am working on
the proper fix for that, but that is not as simple as it seems.

Regards

Marcel



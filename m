Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0BSQjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:39:07 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33681 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BSQjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:39:05 -0500
Subject: One Video Decoding API to rule them all
From: Peter Paul <abnominales@web.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 17:39:00 +0100
Message-ID: <1266597540.2383.20.camel@virtubuntu-alpha>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+r8UpwA3wb1LAZ1Ms+skelh0zP6V/hnSfQm7Ch
	7v/E98BufBbj1YdkAM5ixv6J5mj7IcGtZ7wHxJIX29JKQeJEB9
	0djXNTWR4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
currently we've got three APIs to accelerate video decoding in hardware,
but to cover all available video decoding hardware, an application
writer would have to support all of them.
There is VDPAU which has a prominent supporter with nvida and is
implemented by the proprietary nvidia and S3 driver.
Than there is VA-API that is implemented in the proprietary poulsbo
driver and that can use VDPAU or AMD's proprietary XvBA as a backend.
And more recently we got CrystalHD that is implemented by Broadcom's
eponymous driver and targets their dedicated video decoding chips.
Now there are already applications that take advantage of one or more of
those APIs, but hardly anyone can support all of them, thus always
excluding users of specific hardware.
I think it would therefore be helpful to have an official statement
which API is the preferable one so, that the open source drivers and
applications could migrate to that one.

Regards,
Peter


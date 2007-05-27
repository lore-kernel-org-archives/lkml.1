Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXE0Kry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXE0Kry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXE0Krq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:47:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXE0Krq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:47:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Documentation on /sys/power/resume
Date: Sun, 27 May 2007 12:53:02 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <4658C807.9040005@tmr.com>
In-Reply-To: <4658C807.9040005@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271253.03396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 27 May 2007 01:51, Bill Davidsen wrote:
> Not in the ABI doc, is there and doc at all, and if not could someone 
> who knows where it's used might give me a hint, as a quick look didn't 
> bring enlightenment. Or is it a future hook which doesn't work yet?

That's something that in theory may allow you to resume the system from
and initrd script.

Basically, you write your resume device's major and minor numbers
into it as the "MAJ:MIN" string (eg. "8:3" for /dev/sda3 on my box) and the
kernel will try to read the image from this device and restore it.

It only works with partitions and the use of it us discouraged, so it's
deliberately undocumented.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

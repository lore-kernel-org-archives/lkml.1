Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYBXLI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYBXLI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYBXLIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:08:39 -0500
Received: from mailout05.sul.t-online.de ([194.25.134.82]:38867 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbYBXLIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:08:37 -0500
Message-ID: <47C15020.8040806@t-online.de>
Date: Sun, 24 Feb 2008 12:08:16 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: strange behavior on multimedia eject button for cdrom
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EAlpc4ZFrhg96oxCvM4YrrwQ1RlUg0stSwXGdlR0NgtcGvz7WCK0ONLL5kpSDhZQsR
X-TOI-MSGID: aa59760b-c5e7-47a3-acb1-3bc445b233c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

My laptop (Dell XPS M1330) has some multimedia keys added to the
keyboard, including an eject button for the cdrom drive, instead
of a "regular" eject button built into the drive itself.

When I press it to eject a CD, then Linux becomes pretty mad: The
audio device gets stuck somehow, playing the same tune over and
over again, the network connection is frozen, etc. Once the CD is
out it is back to normal, as it seems.

I would guess that the eject button triggers some bios functionality,
outside of the control of the kernel. But is it? How comes that
Linux seems to loose control in this case?

Kernel is 2.6.24.2 (amd64).

AFAICS this eject button has no keycode. The other multimedia keys
have.


Any helpful idea would be very welcome.


Regards

Harri


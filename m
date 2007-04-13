Return-Path: <linux-kernel-owner+w=401wt.eu-S1030878AbXDMXWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030878AbXDMXWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030889AbXDMXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:22:35 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:40474 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030878AbXDMXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:22:33 -0400
Date: Fri, 13 Apr 2007 17:21:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Loud "pop" coming from hard drive on reboot
In-reply-to: <fa.nTNVZ3bPe8773+gVV7CvcwBT5zY@ifi.uio.no>
To: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-id: <46201062.1030005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nTNVZ3bPe8773+gVV7CvcwBT5zY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> When I reboot my notebook, it powers off and powers back on.
> On poweroff a loud snapping noise seems to be coming from the
> hard drive. Today I noticed there is no "shutdown: hda" on
> the console when I reboot. Whne I do a normal poweroff the
> message is displayed and there is no noise. Should the IDE
> code be changed so it always shuts down the drive?

The question is why the laptop powers off and back on. Do reboots from 
Windows do that? That is why the drive makes so much noise, because the 
kernel didn't standby the drive before rebooting, since it shouldn't 
have to, and yet the drive loses power so it does an emergency retract.

Making the kernel shutdown on reboot would only add more spindown/up 
cycles for normally working systems.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S935874AbXFFWAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935874AbXFFWAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbXFFWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:00:12 -0400
Received: from lucidpixels.com ([75.144.35.66]:49790 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122AbXFFWAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:00:11 -0400
Date: Wed, 6 Jun 2007 18:00:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.22-rc4 netconsole & syslogd bug
Message-ID: <Pine.LNX.4.64.0706061753190.3697@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. I use netconsole on almost all of my machines.
2. When I reboot one of them, it sends the kernel messages to the console
    logging server.
3. However, whenever I reboot it spams the console and every xterm open
    with the following:

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sdb3>

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sda3>

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sdb2>

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sda2>

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sdb1>

Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
p34 sda1>

I also tried:

# Send p34 messages to their own file.
@192.168.0.1        /var/log/p34.log

But no luck here either.

Do I need to be running some sort of special netconsole server and send to 
a different port to avoid this spam?

Justin.


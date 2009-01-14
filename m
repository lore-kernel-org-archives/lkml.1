Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbZANPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbZANPOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbZANPOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:14:12 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:44761 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481AbZANPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:14:10 -0500
Message-ID: <496E013C.3050401@davidnewall.com>
Date: Thu, 15 Jan 2009 01:44:04 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <496DF66B.9050605@davidnewall.com> <20090114144937.GA21043@frolo.macqel>
In-Reply-To: <20090114144937.GA21043@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Thu, Jan 15, 2009 at 12:57:55AM +1030, David Newall wrote:
>   
>> Philippe De Muyter wrote:
>>     
>>> Actually, I was thinking about reducing the footprint of my kernel by
>>> removing all the fs-related system calls, so the problem is not where
>>> the file-system is, but how to access (serial) devices without giving their
>>> "/dev/..." name.
>>>       
>> That's fighting the UNIX design, in "which everything is a file."  You
>> can remove all of the disk-based filesystems, but if you try to remove
>> open, close, read or write there'll be almost nothing that you can
>> usefully do.
>>     
>
> Of course, I need read, write and ioctl and socket and friends but I do not
> need open, creat, link, rename etc.

I think you do need open; how else will you open the serial port?

The best advice I can offer is: Don't think about kernel threads,
user-space is where you should be; and don't think about removing system
calls.  If your application truly is so tight, linux might not be the
right tool for you.

Maybe the embedded linux list might be more in tune with what you're
thinking.

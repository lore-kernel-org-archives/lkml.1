Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXLQAy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXLQAy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbXLQAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:54:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22582 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbXLQAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:19 -0500
Date: Sun, 16 Dec 2007 18:53:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
In-reply-to: <fa.RR732o3u5kvPHNspJA9tM1WHlKI@ifi.uio.no>
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>
Message-id: <4765C892.5090005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.SxdP/X04a85FM81xaEZMBrrv9i4@ifi.uio.no>
 <fa.tplCM7jT7JqanJcCtGK76o+Mdsw@ifi.uio.no>
 <fa.lWVoQaFEkNNX7F+8WUJpMQjIODE@ifi.uio.no>
 <fa.ng4A2MLKS/VR9lS0zt0LDJIDwi0@ifi.uio.no>
 <fa.yZlGBJmYGGt3AQuIiiu7uMT3W9w@ifi.uio.no>
 <fa.RR732o3u5kvPHNspJA9tM1WHlKI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> PS: If I have time, I may try to build Rene's port 80 test for Windows 
> and run it under WinXP on this machine (I still have a crappy little 
> partition that boots it).   If it freezes the same way, it's almost 
> certain a design "feature", and if it doesn't freeze, we might suspect 
> that there is compensating logic in either Windows ACPI code or some way 
> that windows "sets up" the machine.

You'd have to replace the iopl call to an equivalent one for Windows 
(seems like NtSetInformationProcess(ProcessUserModeIOPL) might do what 
you need).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


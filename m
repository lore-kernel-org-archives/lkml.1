Return-Path: <linux-kernel-owner+w=401wt.eu-S938742AbXG1BuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938742AbXG1BuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763328AbXG1Bt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:49:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61441 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760547AbXG1Bt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:49:57 -0400
Date: Fri, 27 Jul 2007 19:49:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problems with reading DVD using 2.6.21.5
In-reply-to: <fa.wwGTjo0zKd+GP1ok2NxTU1KXblw@ifi.uio.no>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <46AAA0BE.5030102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wwGTjo0zKd+GP1ok2NxTU1KXblw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer wrote:
> Hello,
> 
> today I've tried to install Slackware 12.0
> 
> As the installer just "skipped" some install steps, I tried to find the 
> error.
> 
> The problem seems to be unreadable parts on the DVD:
> 
> http://pastebin.com/f381e8a88
> 
> But the DVD is OK. I've checked the MD5sum directly from disc on the 
> same system using the same DVD drive.
> 
> dmesg says:
> 
> http://pastebin.com/f63c5c389
> 
> The kernel, used on the Slackware setup disk, uses SMP, but my hardware 
> doesn't support this (get error on dmesg). May this (SMP kernel on 
> non-SMP system) cause such bugs?
> 
> Is this a known bug? How could code, which breaks DVD access, get into 
> stable 2.6.21.5?

I don't think this is a bug, the drive was told to read a sector and 
returned error SK=03, ASC=02, ASCQ=00 which is "NO SEEK COMPLETE", in 
other words it couldn't find that sector. Could be that the disc is 
marginally readable and only sometimes causes read errors.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


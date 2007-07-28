Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXG1Q3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXG1Q3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXG1Q3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:29:15 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23779 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXG1Q3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:29:14 -0400
Date: Sat, 28 Jul 2007 10:29:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Problems with reading DVD using 2.6.21.5
In-reply-to: <fa.cnztXRn3FAFy2ASRJ66hzuGIJeE@ifi.uio.no>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <46AB6ED2.9050509@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vjnUHp6KnLRFG9J2YsYgbtTFq/w@ifi.uio.no>
 <fa.KUYdQE3sQ4aqYGIgVcGT0tK2bSE@ifi.uio.no>
 <fa.7w3KoCPMvb0KLfn2mDV9W6PWVrs@ifi.uio.no>
 <fa.cnztXRn3FAFy2ASRJ66hzuGIJeE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer wrote:
> Hello,
> 
> I tried to reproduce this bug by mounting/unmounting the drive several 
> times.
> 
> It seems like this problem is caused, if the drive is at speed 0 after 
> some time without access. In this situation, sometimes the drive seems 
> to take a bit longer to speed up. Whenever it takes a bit longer, I get 
> the error in dmesg and parts of the mounted disc are unreadable...
> 
> Any chance to get this debugged?

It's not entirely clear to me whether the kernel is doing any retries or 
not. It likely should be, but somebody more familiar with the block 
layer would likely have to answer whether it will be or not..

Certainly if we are already retrying and the drive keeps saying "no seek 
complete" there's not much the kernel can do about it..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


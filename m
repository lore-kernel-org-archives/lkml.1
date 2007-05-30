Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbXE3O17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbXE3O17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXE3O1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:27:52 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20480 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXE3O1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:27:51 -0400
Date: Wed, 30 May 2007 08:27:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
 motherboards.
In-reply-to: <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <465D89E1.7030301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4kEpre7NAj1mG6fooUMp/WVc8tg@ifi.uio.no>
 <465CF8CA.8070009@shaw.ca> <Pine.LNX.4.64.0705300440530.3755@p34.internal.lan>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Kernel dmesg attached from 8GB bootup.

It looks like part of the start of the output was truncated..

> Robert, how come the option is not applicable in 64-bit mode? If I want 
> to use all 8GB of memory I need to run a 32-bit kernel?
> 
> Justin.
> 

Highmem and PAE (which are essentially what the 4GB/64GB memory options 
control) are not needed in 64-bit mode, since we can access the entire 
64-bit address space directly.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


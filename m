Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbXJXO0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbXJXO0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbXJXO03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:26:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53463 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbXJXO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:26:28 -0400
Date: Wed, 24 Oct 2007 08:26:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
In-reply-to: <fa.7rN1uBoDAvdkB/ZVQAe63J/uvnk@ifi.uio.no>
To: Rajkumar S <rajkumars@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <471F560D.4040909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7rN1uBoDAvdkB/ZVQAe63J/uvnk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rajkumar S wrote:
> Hello,
> 
> I am using a Core 2 Duo E6750 CPU on an intel DG33FB mother board with
> 4GB Ram, running Debian Lenny.
> 
> Since the box has 4 GB ram I compiled a big mem kernel, but the
> machine is very slow while running big mem kernel. It takes about 37
> minutes to compile the intel e1000 driver  (e1000-7.6.5.tar.gz) from
> intel site. But it's performing normally when using a non big mem
> kernel. The diff of the .config between working and non working is as
> follows.

Post your contents of /proc/mtrr. Likely a BIOS bug which has been seen 
on a number of Intel boards, which doesn't mark all of RAM as cachable. 
When the top memory starts being used with the bigmem kernel it causes a 
major slowdown. Check for a BIOS update from Intel, first.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXCIAg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXCIAg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXCIAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:36:29 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63296 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXCIAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:36:28 -0500
Date: Thu, 08 Mar 2007 18:35:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Question about memory mapping mechanism
In-reply-to: <fa.8Fy6n0Le4Y2mDfeEy936/5bbJHA@ifi.uio.no>
To: Martin Drab <drab@kepler.fjfi.cvut.cz>, hugh@veritas.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45F0ABEB.3030201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8Fy6n0Le4Y2mDfeEy936/5bbJHA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Drab wrote:
> Hi,
> 
> I'm writing a driver for a sampling device that is constantly delivering a 
> relatively high amount of data (about 16 MB/s) and I need to deliver the 
> data to the user-space ASAP. To prevent data loss I create a queue of 
> buffers (consisting of few pages each) which are more or less directly 
> filled by the device and then mapped to the user-space via mmap().
> 
> The thing is that I'd like to prevent kernel to swap these pages out, 
> because then I may loose some data when they are not available in time 
> for the next round.

It would likely be easier to just mlock this buffer from the userspace 
application, rather than trying to achieve this in the driver..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


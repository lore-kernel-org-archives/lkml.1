Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbXDJOPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbXDJOPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXDJOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:15:55 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:19866 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbXDJOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:15:54 -0400
Date: Tue, 10 Apr 2007 08:15:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Help Understanding Linux memory management
In-reply-to: <fa.jFpt5NWxHc2YH0jy7hPsDxyUr0E@ifi.uio.no>
To: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <461B9BED.6030208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.jFpt5NWxHc2YH0jy7hPsDxyUr0E@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mouawad, Tony wrote:
> Hello,
> 
> I've been a MS Windows based programmer for a very long time and was
> recently tossed in an environment where I am developing embedded apps on
> the m68k / Linux platform.  That makes me a Linux newbie.  I started
> asking a few questions on various IRC channels and was directed to this
> group.  So, I will start asking:
> 
> These are questions derived from observations on the MCF 5475 CPU
> running Linux 2.6.10 built for the m68k platform.  Disk swapping is
> disabled.
> 
> 1) When physical memory runs low, the memory manager will try to use
> memory currently allocated to the pagecache.  Is this true?

Yes.

> 2) When vm.overcommit_memory = 2 (overcommit disabled), and memory runs
> low, it appears that the memory manager does not try to use memory
> currently allocated to pagecache.  Is this true?

Shouldn't be, what makes you think this is happening?

> 3) Is it possible to disable the pagecache?

Not as far as I know, it's unlikely this would be of any benefit.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


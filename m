Return-Path: <linux-kernel-owner+w=401wt.eu-S2992911AbXDRW67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992911AbXDRW67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXDRW66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:58:58 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:43591 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbXDRW64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:58:56 -0400
Date: Wed, 18 Apr 2007 16:58:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Loud "pop" coming from hard drive on reboot
In-reply-to: <fa.kwrK207qOU0rARQuJJKqsJ7Nk4w@ifi.uio.no>
To: Stephen.Clark@seclark.us, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-id: <4626A289.2080208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.C4axrtm0R4NUqTWfuNUHmUuWy3s@ifi.uio.no>
 <fa.VWJWPLq+/tQvH9AK4UjcjZqbJe4@ifi.uio.no>
 <fa.EnoRw2EXyWNvVcFxHrcbfZBCcsg@ifi.uio.no>
 <fa.M3hXdZRYWoxu+2mG+LfZsZs6AKA@ifi.uio.no>
 <fa.9O8bUjY5F4TzNzCQp6dHXDtOIR0@ifi.uio.no>
 <fa.kwrK207qOU0rARQuJJKqsJ7Nk4w@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> So this is the pop I hear on my new laptop that is using 
> libata=combined_mode
> when I shut my system down. I didn't get the pop with the same disk 
> drive in an older
> laptop that was only ide. It sounds like a relay closing or opening, but 
> is really my
> drive head doing an emergency retract/park?

Yes, that would be what it is, and why.

I would vote that the sd stop-on-shutdown patch should go in, and 
possibly with the new behavior enabled by default. Surely the number of 
people running Linux on a laptop (or any other system with load/unload 
head technology drives) is much greater than the number of people 
running a SAN, multi-initiator, etc. environment where you might not 
want this..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


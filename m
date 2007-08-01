Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbXHAJp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbXHAJp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbXHAJpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:45:16 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21127 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbXHAJpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:45:15 -0400
Date: Wed, 01 Aug 2007 03:42:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Reading a bad sector does not report failure as 'read error' but
 hangs PC with 'Machine Check Exception'
In-reply-to: <fa.iA7ClD7fNtxdfJ9YhG0lqougi/0@ifi.uio.no>
To: "Hendrik ." <chasake@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46B0559A.5050708@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tKSW2T164UTRMvntkUO/fGg0UlM@ifi.uio.no>
 <fa.iA7ClD7fNtxdfJ9YhG0lqougi/0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hendrik . wrote:
> Ok, I did actually not copy the coreret code in the
> mcelog, leaving me some errors about the Northbridge.
> If I do it again it gives me something else. I made 2
> digital photo's of 2 lockups when it happened and this
> is the result of the tool, the TSC is different in
> both errors, the rest is the same:
> 
> --------------------
> CPU 0 4 northbridge TSC b7d4a144d0 
>   Northbridge Watchdog error
>        bit57 = processor context corrupt
>        bit61 = error uncorrected
>   bus error 'generic participation, request timed out
>       generic error mem transaction
>       generic access, level generic'
> STATUS b200000000070f0f MCGSTATUS 4
> This is not a software problem!

Presumably some access that the CPU is doing to the controller has timed 
out and caused the MCE. It might be useful if we could get a stack trace 
from where the MCE was triggered - does anyone know if it's possible to 
do this?

It's possible that only NVidia really could tell why this error would 
result from a disk problem, though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


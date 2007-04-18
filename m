Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDRW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDRW6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDRW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:58:41 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31846 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbXDRW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:58:38 -0400
Date: Wed, 18 Apr 2007 16:57:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Loud "pop" coming from hard drive on reboot
In-reply-to: <fa.8Q2FxIVtQ1sfsfDBeXACAS7rK6Y@ifi.uio.no>
To: Stephen.Clark@seclark.us, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Lord <lkml@rtr.ca>
Message-id: <4626A244.9030205@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.XZdGeaFaW9WSFIAsz5f9RETfH0c@ifi.uio.no>
 <fa.8Q2FxIVtQ1sfsfDBeXACAS7rK6Y@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> I tried this on 2.6.20.2 it applied to libata with some fuzz and I had 
> to manually edit libata.h
> When I did a shutdown I still got the click/pop.
> 
> I also noticed the last thing displayed on the lcd before it goes blank is
> Synchronizing SCSI Disks - then the click/pop.
> 
> HTH,
> Steve

That patch on its own will not help, you also need Tejun's 
stop-on-shutdown patch, otherwise the kernel will not try to stop the 
disk before powering off.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


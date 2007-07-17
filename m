Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXGQBGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXGQBGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbXGQBFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:05:45 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38453 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbXGQBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:05:43 -0400
Date: Mon, 16 Jul 2007 19:07:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv: 2.6.22 is not fixed, but certainly improved
In-reply-to: <fa.9GsXANcxdaaxd0tpVuOSy0KKiew@ifi.uio.no>
To: Charles Shannon Hendrix <shannon@widomaker.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <469C1658.4070204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.9GsXANcxdaaxd0tpVuOSy0KKiew@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> I just compiled 2.6.22.1 on my Kubuntu 7.0.4 system.
> 
> As before, I get errors using my Seagate SATA drives, and setting adma=0
> fixes the problem.  I've posted the exact error/reset messages several times
> before.
> 
> However, I would like to note that it happens far less often with 2.6.22.1
> than it did with 2.6.21.
> 
> The history on my own machine is like this:
> 
> 	2.6.19	perfect, but of course no ADMA/NCQ
> 	2.6.20	horrible, with hard resets starting immediately upon
> 		boot, and taking 15 minutes to finally disable NCQ
> 	2.6.21	bad resets, but they only occured ever 10-30 minutes,
> 		NCQ never disabled
> 	2 6.22	resets infrequent, they are soft resets, and much
> 		quicker than before (i.e. less interruption of my usage)
> 		NCQ is never disabled
> 
> I have no idea why I might be seeing a gradual reduction in the severity of
> the problem, but it seems worth noting.
> 
> I want to point it out in case it means something to anyone working on
> the kernel, especially the SATA code and drivers.
> 
> In the last 4 hours of use, I've seen a single reset.
> 
> On all previous kernels under the same load, I'd already have seen several of
> them, or with 2.6.20, a constant stream of them.

Can you post the output you got from the reset on 2.6.22?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765385AbXE2S4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765385AbXE2S4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764446AbXE2S4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:56:19 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2776 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765283AbXE2S4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:56:17 -0400
Message-ID: <465C7723.9040903@shadowen.org>
Date: Tue, 29 May 2007 19:55:31 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
In-Reply-To: <p738xb8fjv2.fsf@bingen.suse.de>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>> +# don't include <linux/video_decoder.h>
> 
> It would be probably better to define some syntax that makes it possible
> to auto extract those from feature-removal-schedule.txt. Otherwise
> long term this will become messy.

Turns out that we already have Files: entries in f-r-s.txt and so I've
enhanced things to pick them out if they start include/ and check them.
 Works well for the two that exists as of today.

-apw

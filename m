Return-Path: <linux-kernel-owner+w=401wt.eu-S964816AbYDWAXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816AbYDWAXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbYDWAXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:23:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43031 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbYDWAXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:23:24 -0400
Date: Tue, 22 Apr 2008 18:25:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Question re the disk driver for /dev/sr0
In-reply-to: <fa.f1U3hfeZvuA6MOX98ADDtqwI20k@ifi.uio.no>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <480E81E2.70704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.f1U3hfeZvuA6MOX98ADDtqwI20k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> Has something been done to that code that is preventing /dev/sr0 from 
> correctly reporting a busy or not ready status to k3b in the last year or so?
> 
> K3B used to dutifully wait till the drive, on reloading the disc after burning 
> it, was ready to service its verify request.  Now, and for several months or 
> more, k3b attempts to read the drive immediately on the disc's being pulled 
> back in, and of course fails, causing k3b to bail out of the verify phase 
> completely.
> 
> So we are left doing it by hand, a 2 stage process, by first dividing the size 
> of the iso file being burnt by 2048 to get the number of blocks to read, and 
> then feeding dd's output for that many size 2048 blocks to sha1sum.  This 
> works fine but requires the user to understand what it is he is doing. :)

You'll need to provide more details on your setup (like what kind of 
drive and full dmesg). I haven't seen this problem.

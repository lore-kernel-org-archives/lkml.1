Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYDVQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYDVQlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYDVQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:41:39 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:36561 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbYDVQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:41:38 -0400
Date: Tue, 22 Apr 2008 12:41:10 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Question re the disk driver for /dev/sr0
To: linux-kernel@vger.kernel.org
Message-id: <200804221241.10260.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Has something been done to that code that is preventing /dev/sr0 from 
correctly reporting a busy or not ready status to k3b in the last year or so?

K3B used to dutifully wait till the drive, on reloading the disc after burning 
it, was ready to service its verify request.  Now, and for several months or 
more, k3b attempts to read the drive immediately on the disc's being pulled 
back in, and of course fails, causing k3b to bail out of the verify phase 
completely.

So we are left doing it by hand, a 2 stage process, by first dividing the size 
of the iso file being burnt by 2048 to get the number of blocks to read, and 
then feeding dd's output for that many size 2048 blocks to sha1sum.  This 
works fine but requires the user to understand what it is he is doing. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Life exists for no known purpose.

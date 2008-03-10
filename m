Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYCJBqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYCJBqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 21:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYCJBqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 21:46:48 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:59326 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYCJBqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 21:46:47 -0400
Date: Mon, 10 Mar 2008 02:46:38 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Chinner <dgc@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <20080309213441.GQ155407@sgi.com>
Message-ID: <alpine.DEB.1.00.0803100235230.9443@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, David Chinner wrote:
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS.

Yeah, I noticed that too, thanks for verifying this: during the 2nd bisect 
run, the box locked up hard when I accessed the device-mapper. I'm using a 
wrapper script to set up my luks/dm-crypt devices and still have to find 
out which command exactly triggers the lockup. So, maybe the hard lockup 
and the hangs are not so unrelated after all...oh well.

> Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Thanks for your assistance, David, I really appreciate it. I'll try to 
find out more about this dm-crypt thingy....

Christian.
-- 
BOFH excuse #396:

Mail server hit by UniSpammer.

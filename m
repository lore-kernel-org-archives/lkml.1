Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXC0J7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXC0J7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXC0J7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:59:36 -0400
Received: from lucidpixels.com ([75.144.35.66]:37696 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXC0J7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:59:35 -0400
Date: Tue, 27 Mar 2007 05:59:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org
Subject: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Message-ID: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I ran a check on my SW RAID devices this morning.  However, when I did so, 
I had a few lftp sessions open pulling files.  After I executed the check, 
the lftp processes entered 'D' state and I could do 'nothing' in the 
process until the check finished.  Is this normal?  Should a check block 
all I/O to the device and put the processes writing to a particular device 
in 'D' state until it is finished?

Justin.

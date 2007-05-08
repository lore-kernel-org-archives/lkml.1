Return-Path: <linux-kernel-owner+w=401wt.eu-S969280AbXEHXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969280AbXEHXFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968588AbXEHXEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:04:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968757AbXEHXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:04:50 -0400
Date: Tue, 8 May 2007 16:04:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
In-Reply-To: <4640FE35.2070605@gmail.com>
Message-ID: <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <4640FE35.2070605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Kevin Winchester wrote:

> x86_64 UP Athlon64 I get a crash on boot using SLUB.  Switching to SLAB makes
> it go away.  I don't have a serial console, so the best I have is a digital
> photo of as many lines as my VGA console was able to get (60 or so).  Is there
> a better way to capture the oops output so that the full trace canbe seen?
> 
> http://picasaweb.google.com/kjwinchester/Linux/photo#5061982383505227842

It fails to create a slab. There should be some of message above what I 
can see that would indicate what went wrong.

Please try to reboot and specify "slub_debug" as a kernel parameter. If it 
boots then send us the kernel log output. Must have something to do with 
how the scsi slab is created in scsi_setup_command_freelist.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYHUVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYHUVEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYHUVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:04:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46144 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753955AbYHUVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:04:29 -0400
Date: Thu, 21 Aug 2008 17:04:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Hocko <mhocko@suse.cz>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How do I raise the priority of one thread in a multi-threaded
 process?
In-Reply-To: <200808211428.27524.mhocko@suse.cz>
Message-ID: <Pine.LNX.4.44L0.0808211651140.17334-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Michal Hocko wrote:

> On Thursday 21 August 2008 12:58:46 pm Alan Stern wrote:
> > Can anyone tell me how to raise the priority of one thread in a
> > multi-threaded process (using the pthreads library)?  Neither nice(2)
> > nor setpriority(2) is appropriate since they affect the priority of an
> > entire process rather than a single thread.
> 
> Isn't pthread_setschedprio, what you are looking for?

Actually I was looking for pthread_setschedparam().  But it wasn't 
clear at first that I needed to change the policy to SCHED_FIFO and 
that special capabilities were needed.  With those changes it seems to 
work correctly.

Thanks for pointing me in the right direction!

Alan Stern


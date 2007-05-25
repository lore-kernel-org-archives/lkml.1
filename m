Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXEYBUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXEYBUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 21:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXEYBT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 21:19:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55662 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750915AbXEYBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 21:19:58 -0400
Date: Thu, 24 May 2007 18:19:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: young dave <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1 SLUB oops
In-Reply-To: <a8e1da0705241739sc9f22b0x6e0ba225bb4fc5d9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705241819050.768@schroedinger.engr.sgi.com>
References: <a8e1da0705240111l790ee29emdd872cf6c56a5e37@mail.gmail.com> 
 <Pine.LNX.4.64.0705240936360.27844@schroedinger.engr.sgi.com>
 <a8e1da0705241739sc9f22b0x6e0ba225bb4fc5d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, young dave wrote:

> > Reboot with slub_debug as a kernel parameter please.
> 
> Yes, I will enable slub_debug as boot parameter, but it doesn't occur
> definitely.
> 
> I will report the info if it arrive again ASAP.

Thank you. This looks like something overwrote a slab object after it was 
freed.


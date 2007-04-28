Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbXD1XvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbXD1XvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXD1XvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:51:00 -0400
Received: from c-24-22-8-126.hsd1.mn.comcast.net ([24.22.8.126]:56989 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754434AbXD1Xu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:50:59 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 19:50:59 EDT
Subject: Re: Please revert [PATCH] user of the jiffies rounding patch: Slab
From: Arjan van de Ven <arjan@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com>
	 <4633D1A2.6010002@linux.intel.com>
	 <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 28 Apr 2007 16:40:30 -0700
Message-Id: <1177803630.3477.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 16:35 -0700, Christoph Lameter wrote:

> Hmmm... Yes but that looks like it comes from a different function. Slab
> calls
> 
>  __round_jiffies_relative(HZ, cpu))
> 
> And its description says:
> 
> /**
>  *
>  * The exact rounding is skewed for each processor to avoid all
>  * processors firing at the exact same time, which could lead
>  * to lock contention or spurious cache line bouncing.


> This is exactly the wrong thing to do.


is it?


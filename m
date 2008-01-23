Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYAWWG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYAWWG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYAWWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:06:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613AbYAWWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:06:37 -0500
Date: Wed, 23 Jan 2008 14:06:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Wolle <Matthias.Wolle@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LowFree/LowMem problem
Message-Id: <20080123140639.828566dd.akpm@linux-foundation.org>
In-Reply-To: <200801210632.42497.Matthias.Wolle@gmx.de>
References: <200801210632.42497.Matthias.Wolle@gmx.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Jan 2008 06:32:41 +0100 Matthias Wolle <Matthias.Wolle@gmx.de> wrote:
> Hi,
> 
> my company is running several servers with kernel 2.6.23.12.  This are Dual 
> Quad Core servers (CPU Intel) with 16GB RAM using a 32Bit kernel.
> After some days nicely running the oom killer killed our processes.
> Our research discovered that the free low memory was reduced to about 11MB. We 
> found out that the decreasing of low memory is related to the count off 
> executed and ended programs.
> 
> I could reproduce the same bug on a maschine with 2GB RAM without PAE (option 
> 4GB HIGHMEM). The following code reproduces the bug.
> 
> #!/bin/sh
> 
> while [ true ]; do
> 	cat /proc/meminfo| grep LowFree
> done
> 
> Please run this script only on a test system. It reduces the low memory quite 
> fast (within minutes). 

That would be very strange.

> The latest available kernel 2.6.24-rc8 is also affected.
> 

Can you please send the full dmesg output from one such oom-killing event?


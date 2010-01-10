Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937Ab0AJMhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0AJMhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852Ab0AJMhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:37:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33546 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0AJMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:37:08 -0500
Date: Sun, 10 Jan 2010 13:37:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100110123702.GC25323@basil.fritz.box>
References: <20100110020955.GB25323@basil.fritz.box> <20100110063335.GA3005@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110063335.GA3005@hack>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you sure

I don't know if it's really endless, but it's doing a good emulation
of it if it's not.

> 
> On my 32bit machine, it runs for a long time, but finally exits.

That was on 64bit.

proc01 had accumulated several minutes of CPU time when I stopped it.

> From the document of pagemap, it is the mapping of all the virtual pages
> of a process, on x86-32, it should be 4G/4K = 1024*1024 pages, also

Only the mapped ones surely?

Right now it looks like it dumps all the holes and that obviously
will never finish on 64bit which has 47bits of address space.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

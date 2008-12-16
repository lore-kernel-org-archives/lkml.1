Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYLPQcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYLPQcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLPQcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:32:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39984 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbYLPQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:32:34 -0500
Date: Tue, 16 Dec 2008 17:44:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Steigerwald <ms@teamix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: physical memory limit of 64-bit linux
Message-ID: <20081216164443.GY25779@one.firstfloor.org>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161654.17291.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 04:54:16PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> > 
> > Hi!
> > 
> > What is the physical memory limit for 64-bit Linux? I read about 40 bit 
> > address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 (256 TB).
> > 
> > Is 64-bit linux able to use that amount - provided that one would manage to 
> > build it into a machine? Or does it have a lower limit?

It depends on which 64bit Linux; e.g. IA64 has larger limits.

> > Looking into the Google crystal ball gives unclear pictures... I tend to 
> > assume that Linux would handle it, but I am not sure.
> 
> IIRC, the current maximal virtual memory space size of the kernel on x86_64 is 2^46.

Correct.

-Andi

-- 
ak@linux.intel.com

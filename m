Return-Path: <linux-kernel-owner+w=401wt.eu-S1030408AbXBTUMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030408AbXBTUMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXBTUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:12:23 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:27291 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030408AbXBTUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:12:22 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Tue, 20 Feb 2007 21:10:42 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH 1/3] x86_64: additions to the i386
 alternative extensions to support x86_64 architecture
Message-ID: <20070220201042.GD5440@amd.com>
References: <20070219190132.GA6083@amd.com>
 <20070219190709.GC6083@amd.com> <200702192229.22217.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200702192229.22217.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 20 Feb 2007 20:11:01.0358 (UTC)
 FILETIME=[3DE2D8E0:01C7552B]
X-WSS-ID: 69C58A522EG1056063-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 10:29:22PM +0100, Andi Kleen wrote:
> On Monday 19 February 2007 20:07, Joerg Roedel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > This patch adds the necessary changes to extend the i386 alternative
> > instruction framework extension on the x86_64 architecture.
> 
> Looks complicated and somewhat fragile.

The tests on i386 and x86_64 just work fine :-)

> I think I would prefer it if you changed the pad field to a "bit not set"
> cpuid field. Then at least 2 alternatives + a nothing alternative could
> be described too.

I'm not sure I fully understand what you mean. Do you mean to add a
further alternative instruction to the struct for supporting 2 alternative
instructions?

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYCERZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYCERZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYCERY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:24:57 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:34874 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbYCERY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:24:56 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JX9PLP-04-19Q-01
Date: Wed, 5 Mar 2008 18:22:43 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and return page size
Message-ID: <20080305172243.GB27109@escobedo.amd.com>
References: <1203791461.11305.135.camel@nimitz.home.sr71.net> <20080225120951.GA5963@escobedo.amd.com> <1203964750.28196.7.camel@nimitz.home.sr71.net> <20080226202533.GD5963@escobedo.amd.com> <1204134244.5207.28.camel@nimitz.home.sr71.net> <20080305160020
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204734766.23655.32.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 05 Mar 2008 17:21:48.0546 (UTC) FILETIME=[64E5EE20:01C87EE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 08:32:46AM -0800, Dave Hansen wrote:
> Were you able to find any other instances of these bitfields being used
> for kernel<->user communication?

I did not look at that.

> I thought you were going to check to
> see if we could depend on the layout, or if it changed between
> compilers.

But I looked at the ABI specification for i386, powerpc and sparc, where
the layout is defined for those architectures. Therefore I assume that
we can depend on the bitfield layout, as long as we use compilers that
adhere to the ABI specification of an architecture.


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown


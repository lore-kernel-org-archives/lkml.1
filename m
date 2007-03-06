Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbXCFMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbXCFMrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXCFMrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:47:31 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:15541 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933243AbXCFMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:47:30 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Tue, 6 Mar 2007 13:46:52 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64: add reporting of SVM flags to
 /proc/cpuinfo
Message-ID: <20070306124652.GK30318@amd.com>
References: <20070305143601.GF30318@amd.com>
 <20070305143911.GG30318@amd.com> <200703051625.31449.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200703051625.31449.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Mar 2007 12:46:54.0083 (UTC)
 FILETIME=[84A7DD30:01C75FED]
X-WSS-ID: 69F3BD472EG2065002-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 04:25:31PM +0100, Andi Kleen wrote:
> On Monday 05 March 2007 15:39, Joerg Roedel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > This patch adds the advanced SVM reporting to /proc/cpuinfo on the x86_64
> > architecture.
> 
> Adding more fields to /proc/cpuinfo is always somewhat risky because
> there are lots of badly written parsers for it.

Can you point me to some really broken parsers of /proc/cpuinfo to test
with?

> I considered adding the SVM fields myself, but decided against it because
> it didn't seem generally useful enough.

I don't see that this is less important than the power flags in that
file. Some users might be interested to see if their processor has npt
for example by simply looking into cpuinfo.
As I said, would be interested to know more about these badly written
parsers.

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG



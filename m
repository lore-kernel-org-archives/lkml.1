Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbXFAVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbXFAVIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbXFAVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:07:58 -0400
Received: from outbound-mail-42.bluehost.com ([69.89.18.11]:47981 "HELO
	outbound-mail-42.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762129AbXFAVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:07:57 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 14:07:51 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011210.15808.jbarnes@virtuousgeek.org> <p73k5unbcnq.fsf@bingen.suse.de>
In-Reply-To: <p73k5unbcnq.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011407.51779.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 1, 2007 2:14:17 Andi Kleen wrote:
> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > (or we get proper PAT support, which I think would make this problem
> > go away as well).
>
> No it won't. If the basic MTRRs for memory are wrong just having PAT
> support in drivers (which already exist in a limited form already, just for
> UC only) won't change anything.

No obviously just using PAT for drivers wouldn't help, I was thinking more of 
having one PAT type be WB memory, and using it by default for most PTEs 
covering normal memory.  If that's not possible, then it seems sensible to 
try to fix this MTRR problem in a better way, either with something like the 
patch I posted earlier or a more advanced MTRR remapper that runs at early 
boot.  Depending on platform requirements though, that could get complicated 
pretty fast...

Jesse


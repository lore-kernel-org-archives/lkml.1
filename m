Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbXFAVmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbXFAVmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbXFAVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:42:11 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:44174 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761154AbXFAVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:42:09 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 14:41:57 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org>
In-Reply-To: <20070601211943.GO7217@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011441.57149.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
> And normally the MTRRs win, don't they (if I remember the table correctly)
> So if the MTRR says UC and PAT disagrees it might not actually help

I just checked, yes the MTRRs win for UC types.  But it sounds like the cases 
we're talking about are actually situations where there's no MTRR coverage, 
so the default type is used.  The manual doesn't specifically call out how 
memory using the default type interacts with PAT, but it may well be that it 
stays uncached if the default type is uncached.  Again that argues for fixing 
the MTRR mapping problem in some way.

Thanks,
Jesse

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbXF0RRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbXF0RRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXF0RR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:17:28 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2674 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbXF0RR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:17:27 -0400
Message-ID: <46829B8E.3010000@macroscoop.nl>
Date: Wed, 27 Jun 2007 19:17:02 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com> <200706270922.05801.jesse.barnes@intel.com> <4682982B.8060200@macroscoop.nl> <200706271006.16956.jesse.barnes@intel.com>
In-Reply-To: <200706271006.16956.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:

> Yeah, that's what I needed.  end_pfn looks ok, but I guess my test is a 
> little too precise.  It should be if ((highest_addr >> PAGE_SHIFT) < 
> end_pfn) rather than !=. 

Right. That made the message disappear. Nice to know my BIOS is really 
fixed.

Thanks,
Pim

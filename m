Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYHGVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYHGVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYHGVVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:21:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHGVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:21:05 -0400
Message-ID: <489B6710.9000604@kernel.org>
Date: Thu, 07 Aug 2008 14:20:16 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>
In-Reply-To: <1218136365.23770.52.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> VMI relies on relocating the fixmap area to make room for the
> hypervisor. These 2 commits started accessing the fixmap area's and
> using them before VMI got a chance to check if it wants to relocate the
> fixmap area. Once VMI got to the point of relocating the fixmap area's
> it resulted in BUG's.
> 

Could you describe this in more detail?  I am not super-happy about this 
solution if there is a better one, like simply locating the fixmap area 
out of the way to start with.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974AbXCMGVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbXCMGVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXCMGVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:21:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36734 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbXCMGVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:21:38 -0400
Message-ID: <45F642F1.1040405@vmware.com>
Date: Mon, 12 Mar 2007 22:21:37 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ak@suse.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix vmi time header bug
References: <45F5DB00.1070506@vmware.com> <20070312223136.dc6969f3.akpm@linux-foundation.org>
In-Reply-To: <20070312223136.dc6969f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Really truly?   I think we have a _lot_ of declarations which omit the section
> qualifier altogether.  How come they don't all break too?
>   

According to the report I have.  Perhaps a bogus section qualifier does 
more damage than an omitted one.  I'll get gcc  / linker version, but 
this could be a combination of user error, a strange toolchain, and 
perhaps a real bug somewhere.

> (ARM (at least) in fact does require the section tagging on the declaration as
> well as the definition, but we've thus far only fixed that in a couple of places
> which were causing breakage).
>   

Yes, I was surprised by this as well, and I'm still skeptical about this 
being the real cause.  Still, this reportedly fixed the problem, and is 
certainly not a bad thing.

Zach

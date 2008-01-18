Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbYARQFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbYARQFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbYARQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:05:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:54366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbYARQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:05:44 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3) II
Date: Fri, 18 Jan 2008 17:05:40 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
References: <200801161114.239449000@suse.de> <20080118155650.GA20054@elte.hu> <200801181701.04549.ak@suse.de>
In-Reply-To: <200801181701.04549.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181705.41109.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 17:01:04 Andi Kleen wrote:
> 
> > could you please make your queue bisectable?
> 
> The idea was that you git revert the original patches 

Or rather instead of git reverting drop them completely. I'm sure it can 
be done somehow. You should also move 

CPA: Implement change_page_attr_addr entry point for i386

Similar to 64bit.

Needed by PAT patches. Replaces 5ec5c5a2302ca8794da03f8bedec931a2a814ae9

Note: should probably be put before PAT patches to avoid bisect failures later

and

CPA Handle 4K split pages at boot on 64bit

Port the code to check for already split 4K pages at boot over from
32bit to 64bit.

Note: should be probably put before PAT patches to avoid bisect failures later
Signed-off-by: Andi Kleen <ak@suse.de>

in front of the PAT patches like described in their descriptions. I put
them at the beginning and they are independent so that should be possible
without conflicts.

I'm not sure what git commands to use for that, but I'm sure it can be 
done somehow.

-Andi

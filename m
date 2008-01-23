Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYAWHq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYAWHq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYAWHqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:46:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34456 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752417AbYAWHqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:46:49 -0500
Date: Wed, 23 Jan 2008 01:46:53 -0600
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hpa@zytor.com,
       ak@suse.de, adaplas@pol.net, linux-kernel@vger.kernel.org
Subject: Re: Could you please merge the x86_64 EFI boot support patchset?
Message-Id: <20080123014653.6261020c.pj@sgi.com>
In-Reply-To: <1201073166.4945.41.camel@caritas-dev.intel.com>
References: <1194831950.17223.44.camel@caritas-dev.intel.com>
	<20080123010051.969d21fd.pj@sgi.com>
	<1201073166.4945.41.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> This patchset has been merged into Linux 2.6.24.

Excellent.

> Unfortunately, the new EFI support patches do not use EFI memory map for
> system boot up ...  So, I think the resolution for your problem is the
> "struct setup_data" mechanism proposed by H. Peter Anvin.

So you're saying that the EFI in the kernel now still won't support more
than 128 or so chunks of memory in the boottime memory map, because it
still goes via the legacy E820h memory map code?

I'll have to study the code more and give it a try.

Are you optimistic that some variation of H. Peter Anvin's "struct
setup_data" mechanism will make it into 2.6.25 or thereabouts?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

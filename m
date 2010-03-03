Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0CCKXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:23:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0CCKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:23:38 -0500
Date: Wed, 3 Mar 2010 11:23:30 +0100
From: Michal Marek <mmarek@suse.cz>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Barry Song <barry.song@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 00/24] Rename kernel's magic sections for compatibility
 with -ffunction-sections -fdata-sections
Message-ID: <20100303102330.GC15480@sepie.suse.cz>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
 <alpine.DEB.1.10.1002282111280.6474@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1002282111280.6474@dr-wily.mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 11:03:46PM -0500, Tim Abbott wrote:
> On Sat, 20 Feb 2010, Denys Vlasenko wrote:
> 
> > Here is a new version of the -ffunction-sections -fdata-sections patch
> > series based on current Linus tree.
> 
> Aside from patch 17, which I would prefer that Haavard review, these 
> patches look correct (and patch 17 can be safely dropped).  Please 
> consider the rest of Denys' patches in this patch series
> 
> Acked-by: Tim Abbott <tabbott@ksplice.com>

Thanks.


> [...]
>
> Michal, what are your thoughts on this patch series?  The kbuild tree 
> would be a reasonable path for merging these patches.

Yes it would. I'm sorry, I was a bit bussy last two weeks. I'll do some
random tests and add the patches to kbuild-next now. The patches look
simple enough for me and don't actually change any functionality if one
doesn't deliberately use -ffunction-sections -fdata-sections, so I hope
Linus will be fine with merging it for 2.6.34.

Michal

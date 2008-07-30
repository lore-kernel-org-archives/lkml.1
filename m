Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbYG3PO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbYG3PO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYG3POs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:14:48 -0400
Received: from styx.suse.cz ([82.119.242.94]:48115 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbYG3POr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:14:47 -0400
Date: Wed, 30 Jul 2008 17:14:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: dsterba@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
 error: invalid use of undefined type 'struct ipw_network'
In-Reply-To: <1217430670.3335.11.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0807301712080.3768@jikos.suse.cz>
References: <20080727190601.GA764@elte.hu>  <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>  <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com>  <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> 
 <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu>  <20080728214153.GA30511@elte.hu>  <20080730145953.GA15151@ds.suse.cz> <1217430670.3335.11.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, James Bottomley wrote:

> I see the patches came in via a straight email sequence.  They really 
> need to be in a tree somewhere that's pulled into linux-next so this 
> type of thing gets noticed.  Since they're wireless patches, why not 
> send them through John Linville's wireless tree?

Well, the 'wireless' in the name of the driver is misleading, it's not 
'wireless' device at all, it's just a serial modem (character device), 
with 'wireless' in its product name.

I used to have git tree for this driver some time ago, but after the 
driver has been merged, I have dropped it, as I didn't expect any massive 
further development of it. Apparently, David is going on with improving 
the driver (thanks!), so I'll probably resurrect it and ask Stephen to 
pull it into -next again.

Thanks,

-- 
Jiri Kosina

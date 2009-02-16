Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZBPN6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZBPN6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZBPN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:57:52 -0500
Received: from [212.110.162.22] ([212.110.162.22]:58639 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbZBPN5w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:57:52 -0500
X-Greylist: delayed 2035 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 08:57:51 EST
Date: Mon, 16 Feb 2009 14:23:45 +0100
From: Luca Bigliardi <shammash@artha.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
Message-ID: <20090216132344.GN24031@pintsize>
References: <20090202172822.GA2801@pintsize> <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz> <20090216124939.GC23665@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090216124939.GC23665@hack.private>
X-GPG-Keyserver: http://keyserver.linux.it
X-GPG-Keynumber: 0x0AF24BF4
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 08:49 PM, Américo Wang wrote:

> On Mon, Feb 16, 2009 at 01:38:46PM +0100, Jiri Kosina wrote:
> >
> >[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
> >  but isn't appropriate for trivial; adding akpm to cc ]
> >
> >On Mon, 2 Feb 2009, Luca Bigliardi wrote:
> >
> >> * Replace kmalloc() with uml_kmalloc()
> >>   (fix build failure)
> 
> 
> Weird... I sent a patch for this several months ago! I thought
> Jeff had already taken it... No?

I did as well (in June/July 08 IIRC) through usermodelinux-devel mailing
list but the patch didn't hit, so this time I've tried this way.

> >> * Remove unnecessary UM_KERN_INFO in printk()
> >>   (don't display '<6>' while printing info)
> 
> But why only this one, not other UM_KERN_INFO in the same file?

Other lines are preceded by a 'new_text_line' so vprintk 'eats' the token.


Thank you,

luca

-- 
Beware of programmers who carry screwdrivers.
                        -- Leonard Brandwein

http://shammash.homelinux.org/ - http://www.artha.org/ - http://www.yue.it/

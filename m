Return-Path: <linux-kernel-owner+w=401wt.eu-S933337AbXAaS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbXAaS6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXAaS6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:58:20 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:60444 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933337AbXAaS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:58:19 -0500
Date: Wed, 31 Jan 2007 13:58:19 -0500
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Message-ID: <20070131185819.GH7584@csclub.uwaterloo.ca>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de> <20070131172410.GV3754@stusta.de> <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 07:24:54PM +0100, Jan Engelhardt wrote:
> How much different hardware does the (old)floppy.c do? I imagine that
> today, where floppies phase out, there will be, in descending order:
> 
>  * USB floppy drives (atm handled by sd.c, could be better to have sf.c)
>  * FDCs on mainboards
>  * 1.44M drives
>  * 1.2M drives
> 
> Even a working 2.88M, as cool as it sounds, never landed in my hands ever
> since I've been into computing. Perhaps the oldest, smallest disk I once
> had was a 360K 5.25", but the B floppy drive to read it was already
> multi-compliant that read up to 1.2M disks.

So what is wrong with the current floppy driver (other than being 120k
of code apparently)?

As for floppies that should work, well I imagine on x86 that would have
to be 360k and 1200k 5-1/4", and 720k, 1200k and 1440k 3-1/2".  Would
perhaps be nice to still support 160, 180 and 320k on the 5-1/4" drive
too just in case anyone ever wants to read one.  Of course some people
might also want support for the higher capacity formats on the 1440k
drive.  2880k would perhaps be nice too for those few people that have
one (I have only ever seen them on decstations, where I haven't seen any
driver ever), and I think a few IBMs.  I have never seen a 2880k disk.

In non x86 land, I would think there is a seperate floppy driver given
the odd formats of some of those systems.

--
Len Sorensen

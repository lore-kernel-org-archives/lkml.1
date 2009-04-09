Return-Path: <linux-kernel-owner+w=401wt.eu-S936034AbZDISTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936034AbZDISTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbZDISTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:19:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbZDISTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:19:40 -0400
Date: Thu, 9 Apr 2009 20:22:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Imre Gergely <gimre@narancs.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Finding lost memory + kernel messages explained
Message-ID: <20090409182204.GN14687@one.firstfloor.org>
References: <49DDB609.8050405@narancs.net> <87y6ua86f4.fsf@basil.nowhere.org> <49DDF2FF.9030501@narancs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DDF2FF.9030501@narancs.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc to mailing list restored. please don't drop this.

On Thu, Apr 09, 2009 at 04:07:11PM +0300, Imre Gergely wrote:
> Andi Kleen wrote:
> >Imre Gergely <gimre@narancs.net> writes:
> >>That would be around 3896MB. My question is: where does the memory go?
> >>Is it normal to 'lose' that much (~130MB) ?
> >
> >I wrote a paper about this topic some time ago.
> >
> >http://halobates.de/memory.pdf
> >http://halobates.de/memorywaste.pdf
> 
> I tried to understand what you wrote there a bit, but it's still pretty 
> confusing ;)

Modern hardware is complicated.

> [    0.004000] Memory: 3980848k/5177344k available (3115k kernel code, 
> 147212k reserved, 1573k data, 540k init)
> 
> There seems to be 5GB of memory, I don't understand where this is coming 
> from. There is a gap in the mapping 

PCs have memory holes below 1MB and below 4GB. The 4GB hole can be
rather large because it contains IO mappings for all devices.

(lines 16 and 17 in dmesg output on 
> the pastebin), but why? And what's that 147212k reserved?

The paper explains all this.

-Andi

-- 
ak@linux.intel.com -- Speaking for m1yself only.

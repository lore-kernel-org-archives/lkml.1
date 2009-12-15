Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbZLOXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbZLOXsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbZLOXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:48:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760711AbZLOXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:48:20 -0500
Date: Tue, 15 Dec 2009 14:56:30 -0800
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091215225630.GA12918@suse.de>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
 <4AF8B4FF.9050405@zytor.com>
 <20091111153632.944a255c.akpm@linux-foundation.org>
 <20091215143446.8b6a7e57.akpm@linux-foundation.org>
 <4B2810D6.9030309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2810D6.9030309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 02:42:30PM -0800, H. Peter Anvin wrote:
> On 12/15/2009 02:34 PM, Andrew Morton wrote:
> >>>>
> >>>> The proposed solution uses the not yet reserved range from 64 to 127. If
> >>>> more devices are needed, we may push 64 to 16.
> >>>>
> >>>
> >>> Again, why not push these up above 256?
> >>>
> >>
> >> I merged this patch, but made a note-to-self that there are remaining
> >> open issues..
> > 
> > And nothing else happened.  Can we revisit this please?
> > 
> 
> There seem to be people still worried about breaking userspace with
> majors/minors >= 256.  I'm starting to think it is time to actually
> break userspace, and dynamic majors/minors seem as good as any place to
> start, especially since they by definition has to be managed by
> something like udev.  We have had large dev_t for something like six
> years now, and most pieces of software isn't affected at all -- only the
> stuff that manages /dev.

No objection from me, as long as the patch actually works.

But you might want to provide a config option so that loons that still
are running Fedora 3 PPC machines who keep insisting on updating to the
latest kernel version still keep their machines limping along
successfully :)

thanks,

greg k-h

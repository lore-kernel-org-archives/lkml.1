Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbZLPWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbZLPWwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763115AbZLPWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:52:09 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:53173 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763107AbZLPWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:52:02 -0500
Date: Wed, 16 Dec 2009 20:51:50 -0200
From: cascardo@holoscopio.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091216225128.GA7791@holoscopio.com>
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
> 
> 	-hpa

I see no problem in this. Can we make this configurable like the random
minor for block devices was done? Or, perhaps, before making a decision,
we can check what kind of devices are using misc dynamic minor, which
was what I did before writing this patch to count the number of current
in-tree users.

I am currently downloading source code from git since I've lost my disk
recently. That's why I'm late replying. I may send a list of current
users if that's interesting for a better analysis.

Regards,
Cascardo.

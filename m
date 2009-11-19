Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZKSOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZKSOio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZKSOin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:38:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZKSOim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:38:42 -0500
Date: Thu, 19 Nov 2009 15:38:47 +0100
From: Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@sun.com>
Cc: Jan Blunck <jblunck@suse.de>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Explicitly assign values to on-disk enum of
 filetypes
Message-ID: <20091119143846.GB24836@duck.suse.cz>
References: <20091118162550.GP21750@bolzano.suse.de>
 <CE98E2AD-F6E2-4AC7-B43A-BE2893E384F8@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE98E2AD-F6E2-4AC7-B43A-BE2893E384F8@sun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-11-09 23:34:46, Andreas Dilger wrote:
> On 2009-11-18, at 08:25, Jan Blunck wrote:
> >Here is an old patch that I found in my tree. Andreas, it seems
> >that this is something you proposed.
> >
> >Comments?
> 
> This is definitely my preferred coding style for constants that form
> a permanent part of the API/ABI/disk format.
> 
> The enum is useful because some debuggers can display the symbolic
> name of a constant if a named enum is present (though in this case
> it isn't), but it avoids the risk of someone accidentally inserting
> or removing a value in the middle of the enum.
  In this particular case, I don't have a strong opinion... There isn't
much churn in FT_ fields but OTOH it doesn't hurt to have numbers
explicitely assigned and as you write for on-disk format it's really
important to have them fixed. OK, probably I'm slightly in favor of
merging the patch so I've queued it up.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

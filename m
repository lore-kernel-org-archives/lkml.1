Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZLDQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZLDQlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZLDQlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:41:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZLDQla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:41:30 -0500
Date: Fri, 4 Dec 2009 08:41:26 -0800
From: Greg KH <gregkh@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Doc/stable rules: add new cherry-pick logic
Message-ID: <20091204164126.GB1981@suse.de>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
 <20091202154223.GA5895@suse.de>
 <1259823705.10805.49.camel@localhost>
 <20091204015827.GB2589@suse.de>
 <20091204111635.GA28059@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204111635.GA28059@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 12:16:35PM +0100, Sebastian Andrzej Siewior wrote:
> - it is possible to submit patches for the stable queue without sending
>   them directly stable@kernel.org. If the tag (Cc: stable@kernel.org) is
>   available in the sign-off area then hpa's script will filter them into
>   the stable mailbox once it hits Linus' tree.
> - Patches which require others to be applied first can be also specified.
>   This was discussued in http://lkml.org/lkml/2009/11/9/474
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
> Greg, the cherry pick format got acked by stable team didn't it?
> 
>  Documentation/stable_kernel_rules.txt |   22 +++++++++++++++++++++-
>  1 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
> index a452227..8c0aaad 100644
> --- a/Documentation/stable_kernel_rules.txt
> +++ b/Documentation/stable_kernel_rules.txt
> @@ -25,7 +25,27 @@ Rules on what kind of patches are accepted, and which ones are not, into the
>  Procedure for submitting patches to the -stable tree:
>  
>   - Send the patch, after verifying that it follows the above rules, to
> -   stable@kernel.org.
> +   stable@kernel.org. An alternative is to have the tag
> +    Cc: stable@kernel.org
> +   in the sign-off area. Once the patch is merged it will be filtered
> +   into the stable tree even without sending directly to
> +   stable@kernel.org

This is already documented (somewhat poorly) in the paragraph a few
bullets below this one that says:
	 - If the stable@kernel.org address is added to a patch, when it
	   goes into Linus's tree it will automatically be emailed to
	   the stable team.

Can you delete this paragraph, as your documentation is much nicer and
makes more sense?

Care to redo this patch that way?

thanks,

greg k-h

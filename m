Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZHEGWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZHEGWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZHEGWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:22:21 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50824 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZHEGWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rjoLSpBaYP+odPMWMxbac9DdQNiwqUacMQPgs4PO+/VDuasz0vhe6c4SH0s/x0z5pH
         KEhdDKXvnyXV7HQPNfzmLxFuHBcq8MiZeG0PdlSTM9gUqU87vXjK0swj9+wKx1DCw+1H
         l9EkFKAy4agdFcOFtz92qK8Q7PAvBS4xg2oGg=
Date: Wed, 5 Aug 2009 08:22:15 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with Linus' tree
Message-ID: <20090805062215.GA7732@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Borislav Petkov <borislav.petkov@amd.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Doug Thompson <dougthompson@xmission.com>
References: <20090805150933.103de233.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090805150933.103de233.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Aug 05, 2009 at 03:09:33PM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the edac-amd tree got a conflict in
> drivers/edac/amd64_edac.c between commit
> 126b67b8d26f6623d199aa59279f2e3243f2144c ("amd64_edac: fix ECC checking")
> from Linus' tree and commit 793a2a12b43aba669c8b2604a45f000a394f142d
> ("amd64_edac: cleanup amd64_check_ecc_enabled") from the edac-amd tree.
> 
> I don't think the fix in the former patch is required, so I just used the
> latter version.

thanks and yes, you're right. The former patch is less intrusive
and we opted for that one since it is really late in the -rc cycle
but the latter cleans up stuff so that code flow becomes much more
understandable. I'll rediff later and sorry for the inconvenience.

By the way, I see that you're merging edac-amd before tip and I'm going
to need to rebase my tree against tip in the next couple of days since
it depends on a bunch of stuff in it, so could you please switch the
merge order of the two trees so that edac-amd goes after tip?

Thanks.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Regards/Gruss,
    Boris.

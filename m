Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZBKTdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZBKTdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZBKTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:33:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:34309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756106AbZBKTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:33:21 -0500
Date: Wed, 11 Feb 2009 13:33:19 -0600
From: Dean Nelson <dcn@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next	tree
Message-ID: <20090211193319.GA21987@sgi.com>
References: <20090209162520.GA4882@sgi.com> <20090210132555.be1c1462.akpm@linux-foundation.org> <20090211150103.GA15814@sgi.com> <20090211150536.GE10525@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689D7D@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361689D7D@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 10:58:19AM -0800, Luck, Tony wrote:
> > What question was that? Folding back across that distance is not possible
> > in a Git workflow. I do regular cross-builds - the build bug did not trigger
> > with the ia64 defconfig.
> 
> I'm confused by this, as it definitely triggered for me.  Perhaps
> my build scripts do things a bit differently.  Essentially I do:
> 
>         $ for c in `ls arch/ia64/configs`
>         > do
>         >       cp arch/ia64/configs/$i .config
>         >       yes '' | make oldconfig
>         >       make
>         > done
> 
> Which takes the default answer for any new questions that crop
> up.  This enabled the GRU driver in the case of the generic_defconfig,
> and so the build failed because of the lack of asm/uv.h

It always triggers for me as well. I also use generic_defconfig and
request the default for any NEW questions.


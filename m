Return-Path: <linux-kernel-owner+w=401wt.eu-S1751269AbZH1CC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbZH1CC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZH1CCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:02:24 -0400
Received: from ozlabs.org ([203.10.76.45]:56673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZH1CCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:02:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Date: Fri, 28 Aug 2009 11:32:18 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       zajec5@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-acpi@vger.kernel.org,
       kernel-testers@vger.kernel.org, torvalds@linux-foundation.org,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <200908272023.21288.rusty@rustcorp.com.au> <20090827211351.f9c96bfc.sfr@canb.auug.org.au>
In-Reply-To: <20090827211351.f9c96bfc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908281132.19765.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 08:43:51 pm Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Thu, 27 Aug 2009 20:23:20 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > > Rusty/Len: please work out why the title for that patch went silly.
> > 
> > git-quiltimport uses the patch names, and doesn't extract the title.  I
> > assume that's what Stephen uses.  I didn't rename the patch when I rewrote
> > it not to use work_on_cpu.
> 
> git quiltimport assumes "mail-like" patches, so it looks for "From:" and
> "Subject:" lines.  I guess it could be made to use the first line of the
> patch if there is no subject ...

My scripts should all handle Subject: prefixes, I can just start using that.

Thanks,
Rusty.

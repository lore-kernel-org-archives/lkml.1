Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYG3Tqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYG3Tqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYG3TqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:46:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:4535 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYG3TqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GbMCsqboY8mPLzk6I0/E6AbkTCVUEk8LG8jSARicPD+U0qICTXTIcQ2CqSC/HrXAqN
         WruaEr9ABcVgw/uJkp3mTpDd49PJ5dzfaDUSA8r1ViVTQizpD9SmHsoBC/xSoqS/lwI8
         Krpw1mgVryHdy5fMNuRSEVlx5xICsofqcpo9Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 29
Date: Wed, 30 Jul 2008 21:27:41 +0200
User-Agent: KMail/1.9.9
Cc: Bernhard Walle <bwalle@suse.de>, Greg KH <greg@kroah.com>,
       Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au> <20080730090650.79a5a749@kopernikus.site> <20080730021947.def99edc.akpm@linux-foundation.org>
In-Reply-To: <20080730021947.def99edc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302127.42148.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, Andrew Morton wrote:
> On Wed, 30 Jul 2008 09:06:50 +0200 Bernhard Walle <bwalle@suse.de> wrote:
> 
> > * Greg KH <greg@kroah.com> [2008-07-29 21:48]:
> > > > Isn't this the opposite end of the same problem for which Bernhard
> > > > has been repeatedly trying to find a taker for his patch:
> > > > 
> > > > http://article.gmane.org/gmane.linux.kernel.kexec/1882
> > > 
> > > Yes.  It's not the kobject patch at fault here, it's the use of kobjects
> > > so early in the boot process.  That needs to be fixed.
> 
> It was a bit optimistic to stick an unconditional GFP_KERNEL allocation
> into the previously-atomic kobject_init().
> 
> It's only 128 bytes, so why can't we fix both problems thusly?

Fixes the bug for me (also true for previous patch from Bernhard).

Thanks!

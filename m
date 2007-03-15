Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbXCOAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbXCOAOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXCOAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:14:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:53085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964840AbXCOAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:14:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>,
       Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y [Fix CONFIG_COMPAT_VDSO] <- Bad
Date: Thu, 15 Mar 2007 01:13:53 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
References: <200703141013.l2EADP6c027144@fire-2.osdl.org> <loom.20070314T184515-284@post.gmane.org> <20070314170113.9c3c75c7.akpm@linux-foundation.org>
In-Reply-To: <20070314170113.9c3c75c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150113.53212.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 02:01, Andrew Morton wrote:
> > On Wed, 14 Mar 2007 17:52:01 +0000 (UTC) Leroy van Logchem <leroy.vanlogchem@wldelft.nl> wrote:
> > Leroy van Logchem <leroy.vanlogchem <at> wldelft.nl> writes:
> > 

Where does it hang exactly? Do you have a boot log?

> > > > > None whatsoever.  Three people are reporting this and it's a drop-dead
> > > > > showstopper for a 2.6.21 release so we just have to wait until someone
> > > > > wakes up and thinks about it.
> > > 
> > > The topic should be "when CONFIG_HIGHMEM64G=y" imo.
> > > 
> > > I'll try to do my first bi-sect today.
> 
> Thanks.   Please always do reply-to-all.  Cc's restored (and added..)
> 
> > Bisecting went well, after 13 compiles this commit was found:
> > 
> > a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f is first bad commit
> > commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f
> > Author: Roland McGrath <roland@redhat.com>
> > Date:   Fri Jan 26 00:56:46 2007 -0800

Can you please double check this by trying with/without again -- sometimes bisects go bad.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1767035AbXDTJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767035AbXDTJi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767036AbXDTJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:38:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:34703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767035AbXDTJi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:38:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] Dropping CONFIG_REORDER on x86-64 for 2.6.22
Date: Fri, 20 Apr 2007 11:37:45 +0200
User-Agent: KMail/1.9.6
Cc: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
References: <200704191354.52985.ak@suse.de> <46277C36.6030301@linux.intel.com> <yw1x4pnba1fl.fsf@thrashbarg.mansr.com>
In-Reply-To: <yw1x4pnba1fl.fsf@thrashbarg.mansr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200704201137.45799.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 10:35:10 Måns Rullgård wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
> 
> > Andi Kleen wrote:
> >> Rationale:
> >> - It cannot be enabled in normal builds because all current lds
> >> become very slow when they have to handle thousands of sections.
> >>
> >
> > afaik this is only ever reported on SuSE; I've not heard it on any
> > other distro...
> 
> Even with that option set, the full kernel build with my configuration
> finishes in one minute flat on my Gentoo box.  Could it be that the
> linker uses enormous amounts of memory?  I have 4GB so I wouldn't
> immediately notice.

What binutils version do you use? Maybe that particular problem is finally fixed.
Of course would still leave the other issues I listed.

-Andi

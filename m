Return-Path: <linux-kernel-owner+w=401wt.eu-S2992891AbXDDM0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992891AbXDDM0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992892AbXDDM0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:26:08 -0400
Received: from iona.labri.fr ([147.210.8.143]:52399 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992891AbXDDM0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:26:07 -0400
Date: Wed, 4 Apr 2007 14:26:06 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mbind and alignment
Message-ID: <20070404122606.GF3638@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <20070402204202.GC3316@interface.famille.thibault.fr> <200704041352.04525.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704041352.04525.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen, le Wed 04 Apr 2007 13:52:04 +0200, a écrit :
> > So one of those should probably be done to free people from headaches:
> > 
> > - document "start" requirement in the manual page
> > - require len to be aligned too, and document the requirements in the
> >   manual page
> > - drop the "start" requirement and just round down the page + adjust
> >   size automatically.
> 
> This annoyed me in the past too. The kernel should have done that alignment
> by itself. But changing it now would be a bad idea because it would
> produce programs that run on newer kernels but break on olders.
> Documenting it is the only sane option left.

Ok. I already sent a patch to the manpages maintainer.

Samuel

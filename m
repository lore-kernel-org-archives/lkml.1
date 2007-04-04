Return-Path: <linux-kernel-owner+w=401wt.eu-S2992878AbXDDLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992878AbXDDLwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992880AbXDDLwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:52:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992879AbXDDLwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:52:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: mbind and alignment
Date: Wed, 4 Apr 2007 13:52:04 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20070402204202.GC3316@interface.famille.thibault.fr>
In-Reply-To: <20070402204202.GC3316@interface.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041352.04525.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> So one of those should probably be done to free people from headaches:
> 
> - document "start" requirement in the manual page
> - require len to be aligned too, and document the requirements in the
>   manual page
> - drop the "start" requirement and just round down the page + adjust
>   size automatically.

This annoyed me in the past too. The kernel should have done that alignment
by itself. But changing it now would be a bad idea because it would
produce programs that run on newer kernels but break on olders.
Documenting it is the only sane option left.

-Andi

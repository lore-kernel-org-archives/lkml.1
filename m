Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXJ2Rfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXJ2Rfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbXJ2Rfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:35:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbXJ2Rfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:35:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Date: Mon, 29 Oct 2007 18:35:42 +0100
User-Agent: KMail/1.9.6
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com> <1193674988.5035.93.camel@localhost>
In-Reply-To: <1193674988.5035.93.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291835.42826.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Another thing occurs to me:  perhaps numactl would need an additional
> 'nodes' specifier such as 'allowed'.  Alternatively, 'all' could be
> redefined to me 'all allowed'.  This is independent of how you specify
> 'all allowed' to the system call.

cpuset support in libnuma/numactl is still incomplete. I'm also
not sure what the best way to handle this is.

Probably there should be a switch for both.

-Andi

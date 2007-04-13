Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXDMQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXDMQwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXDMQwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:52:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:49234 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbXDMQwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:52:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] cache_k8_northbridges() overflows beyond allocation (Was: 2.6.21-rc5-mm4 (SLUB))
Date: Fri, 13 Apr 2007 18:52:33 +0200
User-Agent: KMail/1.9.6
Cc: Badari Pulavarty <pbadari@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <200704131745.37795.ak@suse.de> <461FB303.2060303@redhat.com>
In-Reply-To: <461FB303.2060303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131852.34192.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 18:42:43 Chuck Ebbert wrote:
> Andi Kleen wrote:
> >> cache_k8_northbridges() is storing config values to incorrect locations
> >> (in flush_words) and also its overflowing beyond the allocation, causing
> >> slab verification failures.
> > 
> > Oops. Thanks for tracking that down, Badari.
> > 
> > Andrew, clear .21 candidate.
> > 
> 
> 2.6.20 as well. Do you want me to submit it?

After it is in .21

-Andi



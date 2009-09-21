Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZIUWzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZIUWzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZIUWzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:55:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51964 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZIUWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:55:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=d8JIjPlKzueIaoi74n5Vtu+eSm+Oxe22EpZPNNQpYhlVW/jAheRV/DDHZelN2Hm+C
	Q0Z1pIBvg0bZkvguHoPfg==
Date: Mon, 21 Sep 2009 15:55:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
       ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       Randy Dunlap <randy.dunlap@oracle.com>, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-ia64@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
In-Reply-To: <Pine.LNX.4.64.0909211258570.7831@sister.anvils>
Message-ID: <alpine.DEB.1.00.0909211553000.30561@chino.kir.corp.google.com>
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909181848.42192.arnd@arndb.de> <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com> <200909211031.25369.arnd@arndb.de> <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0909211258570.7831@sister.anvils>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Hugh Dickins wrote:

> Is it perhaps the case that some UNIX on ia64 does implement MAP_GROWSUP,
> and these numbers in the Linux ia64 mman.h have been chosen to match that
> reference implementation?  Tony will know.  But I wonder if you'd do
> better at least to leave a MAP_GROWSUP comment on that line, so that
> somebody doesn't go and reuse the empty slot later on.
> 

Reserving the bit from future use by adding a comment may be helpful, but 
then let's do it for MAP_GROWSDOWN too.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbYBBAsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbYBBAsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbYBBAr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:47:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759372AbYBBAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:47:56 -0500
Date: Fri, 1 Feb 2008 16:44:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: konrad@darnok.org, linux-kernel@vger.kernel.org, greg@kroah.com,
       michaelc@cs.wisc.edu, dwm@enoyolf.org, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       apw@shadowen.org
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.6)
Message-Id: <20080201164410.2e93f3a4.akpm@linux-foundation.org>
In-Reply-To: <1201911489.3134.79.camel@localhost.localdomain>
References: <20080130213700.GA28529@andromeda.dapyr.net>
	<1201911489.3134.79.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 18:18:09 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Also, move the reserve_bootmem into the ibft_find routines and ensure
> they're only called once on boot.

And note that the reserve_bootmem() interface is about to change.

http://userweb.kernel.org/~akpm/mmotm/broken-out/introduce-flags-for-reserve_bootmem.patch

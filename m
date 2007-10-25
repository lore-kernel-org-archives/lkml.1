Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXJYXiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXJYXiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbXJYXim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:38:42 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:40348 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbXJYXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:38:40 -0400
To: Zach Brown <zach.brown@oracle.com>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and co.	[try #5]
X-Message-Flag: Warning: May contain useful information
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
	<20071025163357.5057.35399.stgit@warthog.procyon.org.uk>
	<47212215.8080003@oracle.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 25 Oct 2007 16:38:38 -0700
In-Reply-To: <47212215.8080003@oracle.com> (Zach Brown's message of "Thu, 25 Oct 2007 16:09:09 -0700")
Message-ID: <aday7dqzrwh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Oct 2007 23:38:39.0460 (UTC) FILETIME=[2B869A40:01C81760]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +static inline void *ERR_CAST(const void *ptr)
 > > +{
 > > +	return (void *) ptr;
 > > +}
 > 
 > Just to nit, surely you don't need the cast inside the function.  The
 > casting happens at the call site between the argument and returned pointer.

The way it's written you kinda do, since it takes a const void * and
returns a plain void *.  But I don't think that's the best way to
write it.

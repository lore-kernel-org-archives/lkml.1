Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbXJZAUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbXJZAUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXJZAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:20:26 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:47223 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXJZAUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:20:25 -0400
Message-ID: <472132C9.20903@oracle.com>
Date: Thu, 25 Oct 2007 17:20:25 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and
 co.	[try #5]
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>	<20071025163357.5057.35399.stgit@warthog.procyon.org.uk>	<47212215.8080003@oracle.com> <aday7dqzrwh.fsf@cisco.com>
In-Reply-To: <aday7dqzrwh.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > > +static inline void *ERR_CAST(const void *ptr)
>  > > +{
>  > > +	return (void *) ptr;
>  > > +}
>  > 
>  > Just to nit, surely you don't need the cast inside the function.  The
>  > casting happens at the call site between the argument and returned pointer.
> 
> The way it's written you kinda do, since it takes a const void * and
> returns a plain void *.

Ah, right, I missed that.

- z

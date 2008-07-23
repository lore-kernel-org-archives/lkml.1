Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGWUnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGWUnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYGWUmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:42:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47177 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYGWUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uTPzpfgDZ7a9yNw7a2zDcgELNkzneISCBT7ZdOrL6j2enrzA9fiTT7umoHRRhUZgUe
         GNaj37+5oC7zFAbf9N7DwdJ2RryZ8QNP31wQgW4m/r7mUi3IvJqqR9iQ0bDyDIAqg5ki
         ItP1ssue4wlLSKMzDvuBzVLrvzSemXwFXUwF4=
Date: Wed, 23 Jul 2008 22:43:35 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723204335.GA14788@ami.dom.local>
References: <1216810696.7257.175.camel@twins> <20080723113519.GE4561@ff.dom.local> <20080723114914.GF4561@ff.dom.local> <20080723.131607.79681752.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723.131607.79681752.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:16:07PM -0700, David Miller wrote:
...
> There will always be a need for a "stop all the TX queues" operation.

The question is if the current way is "all correct". As a matter of
fact I think Peter's doubts could be justified: taking "USHORT_MAX"
locks looks really dubious (so maybe it's not so strange lockdep
didn't get used to this).

Jarek P.

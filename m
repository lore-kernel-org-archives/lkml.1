Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbZAOAzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbZAOAzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbZAOAzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:55:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbZAOAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:55:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=yOM/MH8uuzQxK9NWL3DGEZKYqGfI5agkzdWEQwcSIEmFDjuO6r20VCt6MVNl+DxB0
	OiyfQ+lAYZ5JSvj8LZoww==
Date: Wed, 14 Jan 2009 16:54:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090114192216.GA18123@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901141651540.22699@chino.kir.corp.google.com>
References: <bTx3z-8bU-23@gated-at.bofh.it> <bTxdg-8sZ-23@gated-at.bofh.it> <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.101
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:

> This does not work if processes are short-living and are spawned by the
> parent on demand. If processes have different priority in regards to oom
> condition, this problem can not be solved with existing interfaces
> without changing the application. So effectively there is no solution.
> 

Wrong, you can change how the application is forked.  Either immediately 
adjust /proc/$!/oom_adj or use the adjustment inheritance property and 
change /proc/$$/oom_adj to the desired value prior to forking.  Thanks.

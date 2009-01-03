Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbZACXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbZACXDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZACXDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:03:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZACXDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:03:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090103184921.GB20166@fieldses.org>
References: <20090103184921.GB20166@fieldses.org> <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com> <20090102164505.GA10465@fieldses.org> 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]
Date: Sat, 03 Jan 2009 23:03:26 +0000
Message-ID: <14883.1231023806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> More precisely:
> 	- The last working commit is b6dff3ec... "CRED: Separate task
> 	  security context from task_struct".
> 	- The first commit exhibiting the permissions problem is
> 	  a6f76f2... "CRED: Make execve() take advantage of
> 	  copy-on-write credentials".
> 	- The 9 commits in between (from f1752eec to d84f4f9) result in
> 	  a soft lookup on boot.

Okay, I'll have a look at that, but did you manage to find out if the patch I
posted fixed the problem you originally mentioned?

David

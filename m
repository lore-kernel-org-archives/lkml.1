Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYJGVJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYJGVJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYJGVJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:09:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:35423 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbYJGVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:09:11 -0400
Date: Wed, 8 Oct 2008 08:08:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] user namespaces: introduce user_struct->user_namespace
 relationship
In-Reply-To: <20081007170539.GA525@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0810080807340.10677@tundra.namei.org>
References: <20081004013644.GA24104@us.ibm.com> <alpine.LRH.1.10.0810060846020.30516@tundra.namei.org> <20081006141101.GB15419@us.ibm.com> <alpine.LRH.1.10.0810070847480.4113@tundra.namei.org> <20081007170539.GA525@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Serge E. Hallyn wrote:

> > the fixups could be carried in linux-next, or generate them against 
> > creds-next-subsys for inclusion after that.
> 
> creds-next-subsys is not yet feeding into linux-next, right?

Correct.

> So I should wait until they hit linux-next?

Unless akpm wants to pick up the branch.

> 
> (It makes more sense for me to port userns on top of creds than for
> David to port creds on top of my patches anyway.  I'm actually a bit
> afraid that my refcounting will be complicated by struct creds, but
> we'll see)
> 
> thanks,
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>

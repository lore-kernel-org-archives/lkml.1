Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZLAKe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZLAKe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZLAKe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:34:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:45246 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbZLAKeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:34:25 -0500
Date: Tue, 1 Dec 2009 21:33:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Cong Wang <amwang@redhat.com>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] selinux: remove an unreachable line
In-Reply-To: <4B14D468.2090502@redhat.com>
Message-ID: <alpine.LRH.2.00.0912012131440.27592@tundra.namei.org>
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain> <1259653523.21388.7.camel@Joe-Laptop.home> <4B14D468.2090502@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Cong Wang wrote:

> > >  	default:
> > >  		return -EINVAL;
> > >  	}
> > > -	return -EINVAL;
> > >  }
> > 
> > I think it's better to remove the default case.
> > 
> 
> This is totally a personal taste, I think.
> Either is OK. James, any comments?

Leave the default: there but with a comment /* fall through */
instead of the return.



-- 
James Morris
<jmorris@namei.org>

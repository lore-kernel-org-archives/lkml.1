Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZLVQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZLVQS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZLVQS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:18:57 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:54605 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZLVQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:18:56 -0500
Date: Tue, 22 Dec 2009 10:17:48 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to
 dynamically allocate counters
In-Reply-To: <4B300C97.40409@kernel.org>
Message-ID: <alpine.DEB.2.00.0912221013230.12163@router.home>
References: <20091218222617.384355422@quilx.com> <4B2F2820.5030904@kernel.org> <4B2F2AE8.7060507@kernel.org> <200912220958.16139.rusty@rustcorp.com.au> <4B300C97.40409@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Tejun Heo wrote:

> On 12/22/2009 08:28 AM, Rusty Russell wrote:
> > On Mon, 21 Dec 2009 06:29:36 pm Tejun Heo wrote:
> >> @@ -555,6 +556,7 @@ static void module_unload_free(struct module *mod)
> >>  				kfree(use);
> >>  				sysfs_remove_link(i->holders_dir, mod->name);
> >>  				/* There can be at most one match. */
> >> +				free_percpu(i->refptr);
> >>  				break;
> >>  			}
> >>  		}
> >
> > This looks very wrong.
>
> Indeed, thanks for spotting it.  Christoph, I'm rolling back all
> patches from this series.  Please re-post with updates.

Simply drop the chunk?



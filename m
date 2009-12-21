Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbZLUX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbZLUX2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZLUX2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:28:23 -0500
Received: from ozlabs.org ([203.10.76.45]:57481 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZLUX2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:28:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically allocate counters
Date: Tue, 22 Dec 2009 09:58:15 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20091218222617.384355422@quilx.com> <4B2F2820.5030904@kernel.org> <4B2F2AE8.7060507@kernel.org>
In-Reply-To: <4B2F2AE8.7060507@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912220958.16139.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 06:29:36 pm Tejun Heo wrote:
> @@ -555,6 +556,7 @@ static void module_unload_free(struct module *mod)
>  				kfree(use);
>  				sysfs_remove_link(i->holders_dir, mod->name);
>  				/* There can be at most one match. */
> +				free_percpu(i->refptr);
>  				break;
>  			}
>  		}

This looks very wrong.

Rusty

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbZEATXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbZEATXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZEATXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZEATXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:23:42 -0400
Date: Fri, 1 May 2009 12:14:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: lmb@suse.de, philipp.reisner@linbit.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, gregkh@suse.de, neilb@suse.de,
       James.Bottomley@HansenPartnership.com, sam@ravnborg.org,
       knikanth@suse.de, nab@linux-iscsi.org, kyle@moffetthome.net,
       bart.vanassche@gmail.com, lars.ellenberg@linbit.com
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-Id: <20090501121409.5efac25b.akpm@linux-foundation.org>
In-Reply-To: <20090501131424.GA16852@redhat.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<20090501015902.ed8b56d3.akpm@linux-foundation.org>
	<20090501111554.GW12180@suse.de>
	<20090501131424.GA16852@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 09:14:25 -0400
Dave Jones <davej@redhat.com> wrote:

> On Fri, May 01, 2009 at 01:15:54PM +0200, Lars Marowsky-Bree wrote:
>  
>  > > Is it being used anywhere for anything?  If so, where and what?
>  > 
>  > It is used by many customers (thousands world-wide, I'm sure) to
>  > replicate block device data locally (to replace more expensive SANs
>  > while achieving higher availablity) or async/remotely (for disaster
>  > recovery).
>  > 
>  > The code is rather stable, the first drbd deployments date back many
>  > years - drbd0.7 for example has been shipping with SLES10/9, and 0.6
>  > with SLES8 already. The new drbd8 code is shipping on SLE11 and used
>  > also in combination with OCFS2.
>  > 
>  > So we very much welcome the renewed and persistent interest of merging
>  > the code in mainline (once all serious issues are addressed).
>  > 
>  > Even if in the long-term a merge with other raid implementations is
>  > pursued (which I'd welcome even more), the existence of so many
>  > deployments means we'll need the code for awhile still.
> 
> I've not looked through the patchset, and it's a bit outside my
> domain of expertise, but I can attest we have had requests to
> merge it in Fedora (which we've given the usual "get it upstream" response to).
> The folks who run the Fedora infrastructure have been enthusiastic
> about it for a while (which is why I ended up on the CC for this thread I guess).
> I don't have details about their exact use-cases, but if desired, I can
> find out more.
> 

Oh.  Thanks.  Well we should all get cracking on it then.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765432AbXEYVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765432AbXEYVDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXEYVDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:03:08 -0400
Received: from main.gmane.org ([80.91.229.2]:47637 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764689AbXEYVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:03:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Date: Fri, 25 May 2007 13:58:20 -0700
Organization: Linux Foundation
Message-ID: <20070525135820.7486c548@freepuppy>
References: <20070525163621.GE11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20070525163621.GE11166@waste.org>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
X-Face: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 11:36:22 -0500
Matt Mackall <mpm@selenic.com> wrote:

> 2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
> matter. Bringing up the interface manually still works, so I suspect
> this is sysfs or HAL related again. Again, Debian unstable so
> userspace is quite up-to-date.
> 

Are you renaming network devices? Using /etc/iftab seems to confuse
NM (maybe a HAL problem).

-- 
Stephen Hemminger <shemminger@linux-foundation.org>


Return-Path: <linux-kernel-owner+w=401wt.eu-S935009AbXFGUMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009AbXFGUMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbXFGUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:11:59 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:48696 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbXFGUL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:11:58 -0400
Date: Thu, 7 Jun 2007 16:11:53 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Ingo Molnar <mingo@elte.hu>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>
Subject: Re: [bug] very high non-preempt latency in context_struct_compute_av()
In-Reply-To: <20070607195151.GA30899@elte.hu>
Message-ID: <Line.LNX.4.64.0706071611170.8836@d.namei>
References: <20070604112745.GA26350@elte.hu> <1181244850.11979.66.camel@moss-spartans.epoch.ncsc.mil>
 <20070607195151.GA30899@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Ingo Molnar wrote:

> i have just tried your patch and it completely solves the issue! Without 
> the patch, a simple script that keeps logging in on a box:
> 
> 	while :; do ssh testbox true; done
> 
> would cause glxgears to get into a very jerky motion due to the 
> latencies. With the patch it's 100%, totally smooth! Thanks!
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYLFJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYLFJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 04:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYLFJ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 04:56:13 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41737 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYLFJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 04:56:12 -0500
Date: Sat, 6 Dec 2008 09:56:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Jay Lan <jlan@sgi.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx
 accounting
In-Reply-To: <20081206084223.GA24782@balbir.in.ibm.com>
Message-ID: <Pine.LNX.4.64.0812060950120.22390@blonde.anvils>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils>
 <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils>
 <493975BE.60202@sgi.com> <20081206084223.GA24782@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Balbir Singh wrote:
> 
> Yes, true and getdelays can display all the exported information.
> 
> The race does seem concerning, I would vote for keeping the update in
> there and disabling preemption around the update, so that hiwater
> cannot swing back and forth.

??  Oleg is _fixing_ a race by removing the update from do_exit();
and he is fixing the way the hiwater info was collected in tsacct.c.

Hugh

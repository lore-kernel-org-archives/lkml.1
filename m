Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYKYOr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYKYOr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYKYOrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:47:49 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:40247 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKYOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:47:48 -0500
Date: Tue, 25 Nov 2008 16:43:55 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: jdmason@kudzu.us, discuss@x86-64.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] arch/x86/kernel/pci-calgary_64.c: change
	simple_strtol to simple_strtoul
Message-ID: <20081125144355.GB9912@il.ibm.com>
References: <Pine.LNX.4.64.0811251412330.11897@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811251412330.11897@pc-004.diku.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 02:13:03PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Since bridge is unsigned, it would seem better to use simple_strtoul that
> simple_strtol.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r2@
> long e;
> position p;
> @@
> 
> e = simple_strtol@p(...)
> 
> @@
> position p != r2.p;
> type T;
> T e;
> @@
> 
> e = 
> - simple_strtol@p
> + simple_strtoul
>   (...)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Ingo, can you please push?

Thanks,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/

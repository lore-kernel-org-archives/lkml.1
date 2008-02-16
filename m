Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYBPR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYBPR0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYBPR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:26:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56005 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYBPR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:26:11 -0500
Date: Sat, 16 Feb 2008 09:25:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: geoffrey.levand@am.sony.com, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080216092552.325e5726@laptopd505.fenrus.org>
In-Reply-To: <47B70A61.9030306@tiscali.nl>
References: <47B70A61.9030306@tiscali.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 17:08:01 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> The patch below was not yet tested. If it's correct as it is, please
> comment. ---
> Fix Unlikely(x) == y
> 

you found a great set of bugs..
but to be honest... I suspect it's just best to remove unlikely altogether for these cases;
unlikely() is almost a go-faster-stripes thing, and if you don't know how to use it you shouldn't
be using it... so just removing it for all wrong cases is actually the best thing to do imo.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

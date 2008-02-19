Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbYBSClp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbYBSClp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYBSClh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:41:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYBSClg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:41:36 -0500
Date: Mon, 18 Feb 2008 18:40:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080218184027.429cf47b@laptopd505.fenrus.org>
In-Reply-To: <200802191333.53607.nickpiggin@yahoo.com.au>
References: <47B70A61.9030306@tiscali.nl>
	<20080216094226.1e8eede1@laptopd505.fenrus.org>
	<p731w7axrat.fsf@bingen.suse.de>
	<200802191333.53607.nickpiggin@yahoo.com.au>
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

On Tue, 19 Feb 2008 13:33:53 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> Actually one thing I don't like about gcc is that I think it still
> emits cmovs for likely/unlikely branches, which is silly (the gcc
> developers seem to be in love with that instruction). If that goes
> away, then branch hints may be even better.

only for -Os and only if the result is smaller afaik.
(cmov tends to be a performance loss most of the time so for -O2 and such it
isn't used as far as I know.. it does make for nice small code however ;-)

 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

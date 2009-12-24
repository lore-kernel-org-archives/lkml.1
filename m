Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZLXD6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZLXD6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 22:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZLXD6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 22:58:20 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49851 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZLXD6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 22:58:19 -0500
Date: Thu, 24 Dec 2009 12:58:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 37/37] kgdbts,sh: Add in breakpoint pc offset for superh
Message-ID: <20091224035802.GA28665@linux-sh.org>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com> <1261604584-5796-1-git-send-email-jason.wessel@windriver.com> <1261604584-5796-2-git-send-email-jason.wessel@windriver.com> <1261604584-5796-3-git-send-email-jason.wessel@windriver.com> <1261604584-5796-4-git-send-email-jason.wessel@windriver.com> <1261604584-5796-5-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261604584-5796-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:43:04PM -0600, Jason Wessel wrote:
> The kgdb test suite mimics the behavior of gdb.  For the sh
> architecture the pc must be decremented by 2 for software breakpoint.
> 
> CC: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  drivers/misc/kgdbts.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
This is identical to what I had hacked up locally, so it certainly works
fine.

Acked-by: Paul Mundt <lethal@linux-sh.org>

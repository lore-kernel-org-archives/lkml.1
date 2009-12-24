Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZLXGIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZLXGIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZLXGI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:08:29 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49929 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZLXGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:08:28 -0500
Date: Thu, 24 Dec 2009 15:08:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 14/37] sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
Message-ID: <20091224060811.GF28878@linux-sh.org>
References: <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261603190-5036-7-git-send-email-jason.wessel@windriver.com> <1261603190-5036-8-git-send-email-jason.wessel@windriver.com> <1261603190-5036-9-git-send-email-jason.wessel@windriver.com> <1261603190-5036-10-git-send-email-jason.wessel@windriver.com> <1261603190-5036-11-git-send-email-jason.wessel@windriver.com> <1261603190-5036-12-git-send-email-jason.wessel@windriver.com> <1261603190-5036-13-git-send-email-jason.wessel@windriver.com> <1261603190-5036-14-git-send-email-jason.wessel@windriver.com> <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:19:27PM -0600, Jason Wessel wrote:
> The sci_poll_get_char() needs to return immediately if there is no
> input from the chip to process, and must return a value of
> NO_POLL_CHAR.
> 
> This allows kgdboc to process multiple polled devices while kgdb is
> active.
> 
> CC: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  drivers/serial/sh-sci.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>

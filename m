Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYJ0Lmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYJ0Lmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJ0LmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:42:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19995 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYJ0LmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:42:25 -0400
Date: Mon, 27 Oct 2008 12:42:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Eric Miao" <ymiao3@marvell.com>
Cc: "Mike Rapoport" <mike@compulab.co.il>,
       "Richard Purdie" <rpurdie@linux.intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: CONFIG_LEDS_DA903X=m breaks 2.6.28-rc2-git1 build on x86-64
Message-ID: <20081027124208.72adeae2@hyperion.delvare>
In-Reply-To: <E913911567467945BBEB9277E27868B0013A5EEA@msiexch01.marvell.com>
References: <20081027094509.302401e4@hyperion.delvare>
	<E913911567467945BBEB9277E27868B0013A5EEA@msiexch01.marvell.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, 27 Oct 2008 03:09:25 -0700, Eric Miao wrote:
> This is strange, it compiles OK on ARM, I don't know why this
> failed on x86-64. But anyway, <linux/workqueue.h> should really
> be explicitly included here.
> 
> The attached patch should fix this.

Yes it does, thanks for the quick fix. Please get this upstream quickly
too.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare

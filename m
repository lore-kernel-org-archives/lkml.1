Return-Path: <linux-kernel-owner+w=401wt.eu-S1422974AbXCBGgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422974AbXCBGgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422973AbXCBGgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:36:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422969AbXCBGgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:36:23 -0500
Date: Thu, 1 Mar 2007 22:36:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix for raid6 reshape.
Message-Id: <20070301223619.d9957521.akpm@linux-foundation.org>
In-Reply-To: <1070302045655.19069@suse.de>
References: <20070302155626.19014.patches@notabene>
	<1070302045655.19069@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 15:56:55 +1100 NeilBrown <neilb@suse.de> wrote:

> -	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
> +	conf->expand_progress = (sector_nr + i) * new_data_disks);

ahem.

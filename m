Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYIVSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYIVSMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYIVSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:12:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60509 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYIVSMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:12:03 -0400
Date: Mon, 22 Sep 2008 14:12:20 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922181219.GM16840@redhat.com>
References: <20080922171347.GI16840@redhat.com> <20080922175953.GI10535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922175953.GI10535@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There's a small window when NMI watchdog is being set up that if any 
> > NMIs are triggered, the NMI code will make make use of not initalized 
> > wd_ops elements:
> 
> btw, this looks a bit large and not that easy to trigger, so i think 
> it's v2.6.28 material - agreed?
Yep, this can wait.
Thanks Ingo

-- 
Aristeu


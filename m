Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZGGNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZGGNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZGGNEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:04:08 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47204 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754964AbZGGNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:04:06 -0400
Subject: Re: Possible memory leak via inotify_add_watch
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1246932571.2866.90.camel@dhcp235-23.rdu.redhat.com>
References: <b0943d9e0907061503r7a89a4e2lb5bc76b89e3e8ca6@mail.gmail.com>
	 <1246932571.2866.90.camel@dhcp235-23.rdu.redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 14:03:53 +0100
Message-Id: <1246971833.9451.39.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 13:03:54.0472 (UTC) FILETIME=[61A15E80:01C9FF03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 22:09 -0400, Eric Paris wrote:
> On Mon, 2009-07-06 at 23:03 +0100, Catalin Marinas wrote:
> > Hi Eric,
> > 
> > I'm getting a few kmemleak reports like the one below (it may as well
> > be just a false positive). All of these allocations happened during
> > udevd.
> 
> Any chance you could give this a shot and see if it fixes it up for you?

I'll give it a try tonight as it only shows on my home machine. But it
doesn't apply cleanly on 2.6.31-rc2, there is a big hunk in
inotify_update_watch() which fails to apply. Are there other additional
patches needed?

-- 
Catalin


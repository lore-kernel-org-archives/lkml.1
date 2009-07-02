Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZGBMPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZGBMPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZGBMOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:14:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56766 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZGBMOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:14:55 -0400
Subject: Re: [PATCH] fs/notify/inotify: decrement user inotify count on
 close
From: Eric Paris <eparis@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
       eparis@parisplace.org
In-Reply-To: <1246510598-6136-1-git-send-email-keithp@keithp.com>
References: <1246510598-6136-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:14:49 -0400
Message-Id: <1246536889.22562.74.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 21:56 -0700, Keith Packard wrote:
> The per-user inotify_devs value is incremented each time a new file is
> allocated, but never decremented. This led to inotify_init failing after a
> limited number of calls.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Thanks, I will push to Linus later today, sorry about the regression!

-Eric


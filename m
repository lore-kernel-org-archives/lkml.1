Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYCMWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYCMWki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbYCMWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:40:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbYCMWka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:40:30 -0400
Date: Thu, 13 Mar 2008 15:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: linux-kernel@vger.kernel.org, oleg@tv-sign.ru, roland@redhat.com,
       mingo@elte.hu, xemul@openvz.org
Subject: Re: 2.6.25-rc5-mm1: "consolechars" hangs on boot
Message-Id: <20080313153851.2023980c.akpm@linux-foundation.org>
In-Reply-To: <47D9A5A2.4000009@free.fr>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<47D9A5A2.4000009@free.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 23:07:30 +0100
Laurent Riffard <laurent.riffard@free.fr> wrote:

> Le 11.03.2008 09:14, Andrew Morton a __crit :
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > 
> 
> With 2.6.25-rc5-mm1, my system (Ubuntu 7.10/Gutsy) reliably hangs on
> boot. Sysrq-T shows 12 "consolechars" processes stuck in do_exit call.
> 
> The bisection said "Sucker is
> patches/signals-send_signal-factor-out-signal_group_exit-checks.patch"
> 
> Actually, it's 2.6.25-rc5-mm1 + add-warn_on_secs-macro-fix-fix.patch,
> I guess this patch is innocent.
> 

Actually I later dropped
signals-send_signal-factor-out-signal_group_exit-checks.patch at Oleg's
request.

But I don't think we did that because it was known to be buggy, so perhaps
the same bug crept back in in another form..



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYLLDOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYLLDOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYLLDOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:14:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbYLLDOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:14:32 -0500
Date: Thu, 11 Dec 2008 19:08:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] clocksource: add enable() and disable() callbacks
Message-Id: <20081211190821.9f4b5a5c.akpm@linux-foundation.org>
In-Reply-To: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
References: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 20:49:09 +0900 Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> Add enable() and disable() callbacks for clocksources. This allows
> us to put unused clocksources in power save mode. The functions
> clocksource_enable() and clocksource_disable() wrap the callbacks
> and are inserted in the timekeeping code to enable before use and
> disable after switching to a new clocksource.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> Acked-by: John Stultz <johnstul@us.ibm.com>
> ---
> 
>  Same as before, but applies on top of the new read() patch.

I asusme we'll be seeing some patches which _use_ these changes?

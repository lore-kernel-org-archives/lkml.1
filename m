Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXEJFW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXEJFW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXEJFWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:22:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbXEJFWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:22:49 -0400
Date: Wed, 9 May 2007 22:22:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hirokazu Takata <takata.hirokazu@renesas.com>
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
       hitoshiy@linux-m32r.org
Subject: Re: [PATCH 2.6.21] m32r: Fix switch_to macro to push/pop frame
 pointer if needed
Message-Id: <20070509222235.f4581fa4.akpm@linux-foundation.org>
In-Reply-To: <swfhcql46mb.wl%takata.hirokazu@renesas.com>
References: <swfhcql46mb.wl%takata.hirokazu@renesas.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 13:58:36 +0900 Hirokazu Takata <takata.hirokazu@renesas.com> wrote:

> +#if defined(CONFIG_FRAME_POINTER)
> +    || !defined(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER)

hm, I didn't know that the preprocessor permitted that.

I'll stick a \ in there to be safe.

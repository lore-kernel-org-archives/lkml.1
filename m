Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZBTWP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZBTWP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBTWPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:15:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbZBTWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:15:16 -0500
Date: Fri, 20 Feb 2009 14:15:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, felipe.balbi@nokia.com
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-Id: <20090220141505.d1d53e4b.akpm@linux-foundation.org>
In-Reply-To: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 14:31:17 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

> +struct lm8323_platform_data {
> +	int debounce_time; /* Time to watch for key bouncing, in ms. */
> +	int active_time; /* Idle time until sleep, in ms. */
> +
> +	int size_x;
> +	int size_y;
> +	int repeat : 1;

lm8323_platform_data.repeat appears to be never-written-to?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYGKTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYGKTTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbYGKTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717AbYGKTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:26 -0400
Date: Fri, 11 Jul 2008 12:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] LCD backlight driver using Atmel PWM driver
Message-Id: <20080711121752.56db3d83.akpm@linux-foundation.org>
In-Reply-To: <1215608886-26792-1-git-send-email-hans-christian.egtvedt@atmel.com>
References: <1215608886-26792-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jul 2008 15:08:06 +0200 Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

> +	if (bd->props.power != FB_BLANK_UNBLANK)
> +		intensity = 0;
> +	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
> +		intensity = 0;

hm, is that correct?  It is strange that two different fields can validly
be compared with the same enumeration like this.


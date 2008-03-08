Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYCHQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYCHQNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 11:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYCHQNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 11:13:30 -0500
Received: from saeurebad.de ([85.214.36.134]:37221 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYCHQNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 11:13:30 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare with jiffies
References: <200803080735.06984.hidave.darkstar@gmail.com>
Date: Sat, 08 Mar 2008 17:12:00 +0100
In-Reply-To: <200803080735.06984.hidave.darkstar@gmail.com> (Dave Young's
	message of "Sat, 8 Mar 2008 07:35:06 +0800")
Message-ID: <877igd6vqn.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, Andrew and all

Dave Young <hidave.darkstar@gmail.com> writes:

> +/* time_now_after(a) return true if now (jiffies) is after a */
> +#define time_now_after(a) time_after(jiffies, a)
> +
> +/* time_now_before(a) return true if now (jiffies) is before a */
> +#define time_now_before(a) time_before(jiffies, a)
> +
> +/* time_now_after_eq(a) return true if now (jiffies) is after or equal to a */
> +#define time_now_after_eq(a) time_after_eq(jiffies, a)
> +
> +/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
> +#define time_now_before_eq(a) time_before_eq(jiffies, a)

How about even more obvious names like time_is_past(), time_is_future(),
...?

Sorry, I missed v1.  Should have proposed that earlier.

	Hannes

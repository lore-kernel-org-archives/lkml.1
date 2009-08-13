Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZHMJyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZHMJyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZHMJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZHMJyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:54:11 -0400
Date: Thu, 13 Aug 2009 11:54:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Fix duplicated word "options" in comment
In-Reply-To: <1249502802-15123-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0908131153530.25797@wotan.suse.de>
References: <1249502802-15123-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-2083478803-1250157252=:25797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-2083478803-1250157252=:25797
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 5 Aug 2009, Uwe Kleine-König wrote:

> this was introduced in
> 
> 	5e0a093 (tracing: fix config options to not show when automatically selected)
> 
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: trivial@kernel.org
> ---
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 019f380..6919357 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -68,7 +68,7 @@ config CONTEXT_SWITCH_TRACER
>  # This allows those options to appear when no other tracer is selected. But the
>  # options do not appear when something else selects it. We need the two options
>  # GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
> -# hidding of the automatic options options.
> +# hidding of the automatic options.
>  
>  config TRACING
>  	bool

Haven't seen this in linux-next as of today, so I have put the patch into 
trivial queue. Thanks,

-- 
Jiri Kosina
SUSE Labs
--168427776-2083478803-1250157252=:25797--

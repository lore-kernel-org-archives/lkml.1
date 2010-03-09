Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0CIP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0CIP55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:57:57 -0500
Message-ID: <4B967000.5070904@redhat.com>
Date: Tue, 09 Mar 2010 10:57:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dieter Ries <mail@dieterries.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OPTPROBES: Don't default to y in Kconfig
References: <1268089658-19919-1-git-send-email-mail@dieterries.net>
In-Reply-To: <1268089658-19919-1-git-send-email-mail@dieterries.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> CONFIG_OPTPROBES should not default to y while still being flagged
> EXPERIMENTAL.

Hm, OK, indeed it still needs some more user tests.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Signed-off-by: Dieter Ries <mail@dieterries.net>
> ---
>  arch/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index e5eb133..57710f7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -43,7 +43,7 @@ config KPROBES
>  
>  config OPTPROBES
>  	bool "Kprobes jump optimization support (EXPERIMENTAL)"
> -	default y
> +	default n
>  	depends on KPROBES
>  	depends on !PREEMPT
>  	depends on HAVE_OPTPROBES

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXKJWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXKJWXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXKJWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:23:45 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57692 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbXKJWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:23:45 -0500
Date: Sat, 10 Nov 2007 14:23:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: document make K64BIT=y in README
Message-Id: <20071110142315.39947086.randy.dunlap@oracle.com>
In-Reply-To: <11947274092719-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org>
	<11947274093185-git-send-email-sam@ravnborg.org>
	<11947274091127-git-send-email-sam@ravnborg.org>
	<11947274093213-git-send-email-sam@ravnborg.org>
	<11947274092719-git-send-email-sam@ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 21:43:28 +0100 Sam Ravnborg wrote:

> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  README |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/README b/README
> index 159912c..6622ba1 100644
> --- a/README
> +++ b/README
> @@ -194,6 +194,8 @@ CONFIGURING the kernel:
>     "make *config" checks for a file named "all{yes/mod/no/random}.config"
>     for symbol values that are to be forced.  If this file is not found,
>     it checks for a file named "all.config" to contain forced values.
> +   Finally it checks the environment variable K64BIT and set the config

                                                        and if found, sets
      the config symbol "64BIT" ...


> +   symbol "64BIT" to the value of the K64BIT variable.
>     
>  	NOTES on "make config":
>  	- having unnecessary drivers will make the kernel bigger, and can
> -- 

---
~Randy

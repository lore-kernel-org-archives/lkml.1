Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZF0L1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZF0L1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZF0L0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:26:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZF0L0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:26:52 -0400
Date: Wed, 24 Jun 2009 17:02:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/64] driver core: set default SYSFS_DEPRECATED=n
Message-ID: <20090624150227.GA1784@ucw.cz>
References: <20090616051351.GA23627@kroah.com> <1245131213-24168-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245131213-24168-1-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> All recent distros depend on the non-deprecated sysfs layout, so
> change the default value of the option to reflect that.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  init/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index fed6dc3..c4b3c6d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -616,13 +616,13 @@ config SYSFS_DEPRECATED
>  	bool
>  
>  config SYSFS_DEPRECATED_V2
> -	bool "Create deprecated sysfs layout for older userspace tools"
> +	bool "remove sysfs features which may confuse old userspace tools"

Should begin with capital letter. What is worse, this inverts sense of
description text, but you did not change semantics of the option.

>  	depends on SYSFS
> -	default y
> +	default n
>  	select SYSFS_DEPRECATED
>  	help
>  	  This option switches the layout of sysfs to the deprecated
> -	  version.
> +	  version. Do not use it on recent distributions.

Recent is relative. 'On distros from 2008 and onwards'?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

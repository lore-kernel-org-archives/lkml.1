Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbZICLMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbZICLMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZICLMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:12:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZICLMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:12:01 -0400
Date: Thu, 3 Sep 2009 13:12:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] module: preferred way to use MODULE_AUTHOR
In-Reply-To: <1251450984.3456.3.camel@johannes.local>
Message-ID: <alpine.LNX.2.00.0909031311540.23856@wotan.suse.de>
References: <1251450984.3456.3.camel@johannes.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Johannes Berg wrote:

> For the longest time now we've been using multiple
> MODULE_AUTHOR() statements when a module has more
> than one author, but the comment here disagrees.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/linux/module.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- wireless-testing.orig/include/linux/module.h	2009-08-28 11:12:34.000000000 +0200
> +++ wireless-testing/include/linux/module.h	2009-08-28 11:13:52.000000000 +0200
> @@ -127,7 +127,10 @@ extern struct module __this_module;
>   */
>  #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
>  
> -/* Author, ideally of form NAME[, NAME]*[ and NAME] */
> +/*
> + * Author(s), use "Name <email>" or just "Name", for multiple
> + * authors use multiple MODULE_AUTHOR() statements/lines.
> + */
>  #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
>    
>  /* What your module does. */

Applied, thanks Johannes.

-- 
Jiri Kosina
SUSE Labs

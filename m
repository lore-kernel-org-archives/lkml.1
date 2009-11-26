Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZKZQMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZKZQMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZKZQMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:12:00 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36099 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZKZQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:11:59 -0500
Message-ID: <4B0EA8B0.10703@s5r6.in-berlin.de>
Date: Thu, 26 Nov 2009 17:11:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Teemu Likonen <tlikonen@iki.fi>,
       Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <error27@gmail.com>,
       Martin Olsson <martin@minimum.se>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC] Codingstyle: allow omitting braces for all single
 statement branches
References: <1259227618-1466-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259227618-1466-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> Grepping for "} else$" in v2.6.32-rc8 yields 6440 hits.  So this seems
> to be common practice and should be allowed.

Flawed reasoning.  Is this in new and otherwise stylistically
well-written code?  Or did you perhaps grep in old code or even in staging?

> checkpatch doesn't warn about both variants.

What checkpatch does/ can do, or doesn't, is only indirectly related to
good style or canonical style.

> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -168,15 +168,23 @@ Do not unnecessarily use braces where a single statement will do.
>  if (condition)
>  	action();
>  
> -This does not apply if one branch of a conditional statement is a single
> -statement. Use braces in both branches.
> -
> -if (condition) {
> -	do_this();
> -	do_that();
> -} else {
> -	otherwise();
> -}
> +If not all branches of a conditional statement are single statements you might
> +use braces for both branches.
> +
> +	if (condition) {
> +		do_this();
> +		do_that();
> +	} else
> +		otherwise();
> +
> +or
> +
> +	if (condition) {
> +		do_this();
> +		do_that();
> +	} else {
> +		otherwise();
> +	}
>  
>  		3.1:  Spaces
>  

Either don't remove the existing paragraph, or remove it --- but do not
add your new either-or paragraph.  If you consider both variants to be
OK, you don't need to bloat the style guide by documenting them both.
There is no third or fourth alternative.
-- 
Stefan Richter
-=====-==--= =-== ==-=-
http://arcgraph.de/sr/

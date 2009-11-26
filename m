Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbZKZOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbZKZOxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbZKZOxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:53:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:41532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZKZOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:53:14 -0500
Subject: Re: [PATCH RFC] Codingstyle: allow omitting braces for all single
 statement branches
From: Peter Zijlstra <peterz@infradead.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Teemu Likonen <tlikonen@iki.fi>,
       Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <error27@gmail.com>,
       Martin Olsson <martin@minimum.se>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1259227618-1466-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259227618-1466-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 15:52:59 +0100
Message-ID: <1259247179.31676.112.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 10:26 +0100, Uwe Kleine-König wrote:

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

Andrew recently objected to this pattern, and I tend to agree with him
although I might be guilty of a few such cases myself.


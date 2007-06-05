Return-Path: <linux-kernel-owner+w=401wt.eu-S1764598AbXFEKqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764598AbXFEKqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764094AbXFEKqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:46:02 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:11388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764061AbXFEKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z5vRA8UmSicg7fuQdNnEHO7/hj3smMRnAWYr+TdVGnL+hJWwLgoBby0pmSZ8q8OQfZs7iyAGVISzdHBsSiXsF+FE8uJPm6cjw7NA7iTL5mMg+Sok3UvnPqKMHWrqaVCATt7EMNG0N05dnvGVgS7rqMjOPx1dRytXIhBZfC3jFWk=
Subject: Re: [RFC: 2.6 patch] drivers/video/pm3fb.c: possible cleanups
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070604221257.GD5500@stusta.de>
References: <20070604221257.GD5500@stusta.de>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 18:45:54 +0800
Message-Id: <1181040354.5023.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 00:12 +0200, Adrian Bunk wrote:
> This patch contains the following possible cleanups:

> -
> -int __init pm3fb_init(void)
> -{
> -	/*
> -	 *  For kernel boot options (in 'video=pm3fb:<options>' format)
> -	 */
> -#ifndef MODULE
> -	char *option = NULL;
> -
> -	if (fb_get_options("pm3fb", &option))
> -		return -ENODEV;

The cleanup is good, but we should still leave the above with
the second parameter as NULL so the driver can also listen to
global options, such as video=pm3fb:off.

I'll fix this up. Thanks.

Krzysztof,

I think this patch is okay.  If you need to add an option parser
for your driver, you can always add this in the future.

Tony



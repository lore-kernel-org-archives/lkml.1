Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZKAPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZKAPxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZKAPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:53:46 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60815 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZKAPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tfguUaB2Xgfu9QWAIjEqBxh0vATFRcx1FwzkQ0ECPz8V2l1LqmL+HvIhXviDbJnpX5
         mrBRa1UwIxeWLwkGG3OfztKTtkYcYrCAWlej7YIOn6KYHDweL+0UC5zL7ICh0GAeEXfe
         Ku1ocAKv2kGzbAEOGmfC5H+t1z2lN8HKaoXiw=
Date: Sun, 1 Nov 2009 18:53:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove /proc/*/status "Stack usage:"
Message-ID: <20091101155345.GA3867@x200>
References: <20091101131518.GA18284@x200>
 <1257086397.31587.5.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257086397.31587.5.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 03:39:57PM +0100, Stefani Seibold wrote:
> Am Sonntag, den 01.11.2009, 16:15 +0300 schrieb Alexey Dobriyan:
> > We have /proc/*/pagemap to determine how much stack was consumed.
> > Leave "threadstack" though.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> 
> Stop! /proc/*/pagemap is not a real substitute for the stackm usage
> patch. If you have problems with this patch i will have a look on it.

Why?

You grab thread stack start from /proc/*/stat, then for every page of
stack VMA, you lookup state of page, which is exactly what you're doing
by employing page walker.

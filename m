Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbYBOVX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbYBOVX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYBOVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:23:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:64992 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYBOVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wxYne3T+sUAsMxol5R0rGkx7unh37IeKoB59MPrckmWJniJcUnYgNm32pKvX6Ik1rJsXvhNTvoOSovqs27Gbds99KlZXxghSGkOnqDFiWTvnIWDjHH60fiXhlfsa5rYOHdLgHTUzx9X6GyfNH1T5JUjCGsiNqVl478B16kW9DOU=
Subject: Re: [PATCH] befs: fix sparse warning in linuxvfs.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rathamahata@php4.ru, linux-kernel@vger.kernel.org
In-Reply-To: <20080215131922.0d0dcb08.akpm@linux-foundation.org>
References: <1203101164.15275.21.camel@brick>
	 <20080215131922.0d0dcb08.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 13:23:46 -0800
Message-Id: <1203110626.15275.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 13:19 -0800, Andrew Morton wrote:
> On Fri, 15 Feb 2008 10:46:04 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Use link as the variable name to avoid shadowing the arg.
> > 
> > fs/befs/linuxvfs.c:492:8: warning: symbol 'p' shadows an earlier one
> > fs/befs/linuxvfs.c:488:77: originally declared here
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > This should be checked in case there is a latent bug here.  Should it
> > be the arg *p getting freed, or the local var *p that was shadowing
> > it?
> > 
> 
> The code looks OK - the name was allocated in befs_follow_link() and was
> saved away with nd_set_link().

OK, that's as far as I got as well, but don't know the area well enough
to be sure, hence the caveat.

Harvey


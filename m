Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKZE4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKZE4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKZE4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:56:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26612 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYKZE4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:56:05 -0500
From: Andrey Mirkin <major@openvz.org>
To: Louis.Rilling@kerlabs.com
Subject: Re: [PATCH 1/2] Add flags for user-space and in-kernel process creation
Date: Wed, 26 Nov 2008 08:55:45 +0400
User-Agent: KMail/1.8.2
Cc: Andrey Mirkin <major@openvz.org>, orenl@cs.columbia.edu,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1227541175-30301-1-git-send-email-major@openvz.org> <1227541175-30301-2-git-send-email-major@openvz.org> <20081124160211.GE27238@hawkmoon.kerlabs.com>
In-Reply-To: <20081124160211.GE27238@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811260755.46949.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2008 19:02 Louis Rilling wrote:
> On 24/11/08 18:39 +0300, Andrey Mirkin wrote:
> > Introduce 2 flags for user-space and in-kernel process creation during
> > restart procedure.
> > Also a stub function for in-kernel process restart is introduced.
>
> [...]
>
> > diff --git a/checkpoint/sys.c b/checkpoint/sys.c
> > index 7745500..e4a9287 100644
> > --- a/checkpoint/sys.c
> > +++ b/checkpoint/sys.c
> > @@ -264,8 +264,8 @@ asmlinkage long sys_restart(int crid, int fd,
> > unsigned long flags) pid_t pid;
> >  	int ret;
> >
> > -	/* no flags for now */
> > -	if (flags)
> > +	if ((flags & (CR_CTX_RSTR_IN_USERSPACE | CR_CTX_RSTR_IN_USERSPACE)) ==
> > +			(CR_CTX_RSTR_IN_USERSPACE | CR_CTX_RSTR_IN_USERSPACE))
>
> I guess that the intent was:
> +	if ((flags & (CR_CTX_RSTR_IN_USERSPACE | CR_CTX_RSTR_IN_KERNEL)) ==
> +			(CR_CTX_RSTR_IN_USERSPACE | CR_CTX_RSTR_IN_KERNEL))
>
> ?

Oh, of course it should be like this.
I've sent wrong patch. Will resend correct one.

Andrey

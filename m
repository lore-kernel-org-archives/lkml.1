Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbZLCHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbZLCHMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZLCHMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:12:42 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52545 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZLCHMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QaWOzRER5/qgjTM7Sdd33qef2QNbbw0i0DxQP4+ZBsZycibT7E9wHVTdMdISnZznqF
         MIhKcCthG1loWX85KkcYQOX8sMXeUKGdDgnzF/TvjfaEsR6cgk5U+XCHkPZtsyAx/lsf
         qgzvDFtREXnu+uNh2iboRABv+3nd8iU9YnhW8=
Date: Wed, 2 Dec 2009 23:12:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: liu pf <kernelfans@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
Message-ID: <20091203071244.GI9121@core.coreip.homeip.net>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com> <20091202230746.611f7fc5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202230746.611f7fc5@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:07:46PM -0800, Arjan van de Ven wrote:
> On Thu, 3 Dec 2009 14:49:14 +0800
> liu pf <kernelfans@gmail.com> wrote:
> 
> > Hi:
> > 
> > I am puzzled with the following scenario. Could anyone enlighten me?
> 
> 
> sleep_on family of APIs is very racy and just cannot be used correctly;
> I'm not surprised that there's a preempt race in it, but trust me, it's
> not the biggest race... never ever use these APIs!!!
> 
> 

BTW, why do we still have them? I checked couple and they don't seem to
be used...

-- 
Dmitry

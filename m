Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYEKV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYEKV2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYEKV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:28:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbYEKV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:28:26 -0400
Date: Sun, 11 May 2008 14:27:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] isdn/capi: return proper errnos on module init
Message-Id: <20080511142744.6affe6d0.akpm@linux-foundation.org>
In-Reply-To: <20080511212117.GB1641@uranus.ravnborg.org>
References: <20080511210707.GA25600@pingi.kke.suse.de>
	<20080511212117.GB1641@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 23:21:17 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, May 11, 2008 at 11:07:07PM +0200, Karsten Keil wrote:
> > cdebug_init is called from kcapi_init which is module initialization function,
> > so it must return negative values on errors
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Acked-by: Karsten Keil <kkeil@suse.de>
> 
> Hi Karsten.
> 
> Lately David Miller has started to include isdn patches
> in his netdev tree. So I think you should pass then on to David
> and not Andrew.
> David or Andrew will correct me if I'm wrong...

That's news to me, but I'm easy either way.  Another set of eyes never
hurts.  Dave: your call, please.


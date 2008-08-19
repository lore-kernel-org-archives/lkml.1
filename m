Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYHSTnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYHSTnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYHSTmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:42:55 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:37410 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYHSTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzV8bnsnAbdESymQsoZcEwV0hpwSRnfDMtHbBmEk/lrk1GEYjE4ecYpkmXwRcTTess
         L+X/SPvkjR+LD4Uz/3wtdtKugL0bYlZfDehV43KABjXVJiiDqls3VRAPQVfC/CFU+QQQ
         WyhPMCH9qFkNv9kRejpAGa1f2ixDHt5b+z1ow=
Date: Tue, 19 Aug 2008 15:42:50 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - Fix printk() format warning
Message-ID: <20080819154138.ZZRA012@mailhub.coreip.homeip.net>
References: <aday72srejx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday72srejx.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Tue, Aug 19, 2008 at 12:27:14PM -0700, Roland Dreier wrote:
>     drivers/input/evdev.c: In function 'handle_eviocgbit':
>     drivers/input/evdev.c:684: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> 

Geert beat you to it, I have just committed his fix, but thanks
anyway and sorry about the mess-up.

-- 
Dmitry

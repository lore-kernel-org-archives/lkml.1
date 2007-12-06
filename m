Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbXLFQrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbXLFQrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXLFQqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:46:55 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54253 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXLFQqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:46:54 -0500
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
In-Reply-To: <20071206102334.GE17299@elte.hu>
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 08:34:06 -0800
Message-Id: <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The port_mutex is actually a semaphore, so easily converted to a 
> > struct mutex.
> > 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> cool. How far away are we from being able to remove all the semaphore 
> code? :-)

I wish my 7 patches made a dent, but it's hasn't done much. ;(

I would guess at least a week just to mop up the relatively easy ones..
I've got 12 in my queue, and there still ~50 hopefully trivial ones
still to be looked at.. Then another ~30 more difficult ones (that use
init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..

Daniel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab0BYQjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:39:10 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:52855 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932884Ab0BYQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:39:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rdUeUBs2h+ZOWgSm4Bh81k/HjM+JrKTFaN1UKSpkS4duY8wVK3xTrbSdf/g9+jVBOOhb+RhgH1KYng09RlWz9iCyjm47HQYLyTUjN1vTmcb73OfShZoAJZXcjDJxu32u;
Date: Thu, 25 Feb 2010 08:39:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>
Subject: Re: [PATCH 3/7] kms,kdb: Force unblank a console device
Message-ID: <20100225083922.4ef2ce7b@jbarnes-piketon>
In-Reply-To: <1266014188-29505-4-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
	<1266014188-29505-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 16:36:24 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> The kgdboc pre exception handler must atomically save the state of the
> existing VC console and activate it, if it is blanked.
> 
> Before restoring the kernel to a running state, the kgdboc post
> exception handler will restore the state of the VC variables that got
> changed while atomic.
> 
> CC: David Airlie <airlied@linux.ie>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---

Ugg VT.  But still,

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

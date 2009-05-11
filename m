Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZEKTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZEKTAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZEKTAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:00:25 -0400
Received: from gw.goop.org ([64.81.55.164]:51327 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZEKTAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:00:24 -0400
Message-ID: <4A0875C7.7070305@goop.org>
Date: Mon, 11 May 2009 12:00:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 03/11] Xen: Rename the balloon lock
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <1241732737-7669-4-git-send-email-jeremy@goop.org> <20090508020123.GE25512%yamahata@valinux.co.jp>
In-Reply-To: <20090508020123.GE25512%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> Hi. Please please don't move the arch common variable
> into x86 specific file. It causes link error on ia64.
>
> Before I sent the patches to fix it twice or so,
> but it seems to be dropped.
>   

Sorry, I can't seem to find them.  Could you resend?

I guess there's the larger issue of whether the 
xen_create_contiguous_region() code is also useful on ia64.  It seems to 
me the options are:

    * it is, so we should move the code somewhere common (along with the
      lock)
    * it isn't so ia64 will have its own version (in which case it can
      define its own version of the lock without much impact)
    * or we could move the lock anyway, but there's no very obvious
      place to put it

    J

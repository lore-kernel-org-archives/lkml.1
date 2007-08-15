Return-Path: <linux-kernel-owner+w=401wt.eu-S934763AbXHOSHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763AbXHOSHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbXHOSHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:07:08 -0400
Received: from gw.goop.org ([64.81.55.164]:56055 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXHOSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:07:06 -0400
Message-ID: <46C34043.1060203@goop.org>
Date: Wed, 15 Aug 2007 11:04:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       glommer@gmail.com
Subject: Re: [PATCH 0/25][V3] pvops_64 last round (hopefully)
References: <11871821854176-git-send-email-gcosta@redhat.com>
In-Reply-To: <11871821854176-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This is hopefully the last iteration of the pvops64 patch.
>
> From the last version, we have only one change, which is include/asm-x86_64/processor.h: There were still one survivor in raw asm.
> Also, git screwed me up for some reason, and the 25th patch was missing the new files, paravirt.{c,h}. (although I do remember having git-add'ed it, but who knows...)
>
> Andrew, could you please push it to -mm ?

Hm, I have a patch here to refactor the pv-ops interface into smaller
pieces.  It needs a respin against 32-bit, and obviously 64-bit should
be equivalent.  Its mostly a moving things around patch rather than a
big semantic change, so changing the users of the interface is fairly
straightforward.  I'll post it shortly, but if everyone agrees that its
the way we want to go, we should probably start out with it on 64-bit.

    J

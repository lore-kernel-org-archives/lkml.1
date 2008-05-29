Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYE2LuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYE2LuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYE2LuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:50:01 -0400
Received: from jaguar.mkp.net ([192.139.46.146]:57565 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYE2LuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:50:00 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmtimer: Push BKL down into the ioctl handler
References: <20080522214244.457da3d7@core>
From: Jes Sorensen <jes@sgi.com>
Date: 29 May 2008 07:49:59 -0400
In-Reply-To: <20080522214244.457da3d7@core>
Message-ID: <yq0r6bls520.fsf@jaguar.mkp.net>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

Alan> Switches to unlocked_ioctl read to remove ioctl BKL method. Fix
Alan> the unknown ioctl return. Probably a nice easy one to kill off
Alan> BKL usage entirely later

Alan> Signed-off-by: Alan Cox <alan@redhat.com>

Looks good to me, I should check whether we can't just kill the
lock_kernel() here - I suspect it shouldn't be an issue.

Acked-by: Jes Sorensen <jes@sgi.com>

Cheers,
Jes

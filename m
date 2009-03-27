Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbZC0AvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbZC0AvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762995AbZC0AuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:50:09 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:37933 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933676AbZC0AuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:50:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cVR+8D+t2t5R4rYFRFNuONpJATpQRSGekzm/tTRjOr5cxnWrLz/Lg+81emCzRD/4cnAPyoA/pi18UjXj3HhNDxzB6TfsZTm9Kw295YKODzvBuQNniICp8ug08s2Etnto;
Date: Thu, 26 Mar 2009 17:50:02 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 3/6] drm/i915: Fix lock order reversal in shmem pwrite
 path.
Message-ID: <20090326175002.2011bc75@hobbes>
In-Reply-To: <1238017510-26784-4-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<1238017510-26784-3-git-send-email-eric@anholt.net>
	<1238017510-26784-4-git-send-email-eric@anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 14:45:07 -0700
Eric Anholt <eric@anholt.net> wrote:

> Like the GTT pwrite path fix, this uses an optimistic path and a
> fallback to get_user_pages.  Note that this means we have to stop
> using vfs_write and roll it ourselves.
> 
> Signed-off-by: Eric Anholt <eric@anholt.net>

Ashame that it's so similar but can't share more code...

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

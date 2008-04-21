Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYDUQ4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYDUQ4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYDUQ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:56:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYDUQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:56:37 -0400
Date: Mon, 21 Apr 2008 11:50:50 -0500
From: David Teigland <teigland@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] linux/{dlm,dlm_device}.h: cleanup for userspace
Message-ID: <20080421165050.GA14153@redhat.com>
References: <1208662190-3531-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208662190-3531-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 11:29:50PM -0400, Mike Frysinger wrote:
> linux/dlm_device.h uses types from dlm.h and types.h, so pull them in.  The
> dlm.h header should use __u## rather than uint##_t types and thus pull in
> linux/types.h for it.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/linux/dlm.h        |    3 ++-
>  include/linux/dlm_device.h |    7 +++++++
>  2 files changed, 9 insertions(+), 1 deletions(-)

Thanks, added to dlm.git, will include this in the set for merging.
Dave


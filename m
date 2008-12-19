Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYLSUFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLSUFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYLSUFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:05:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:34146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYLSUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WHRNeWvUZrz/bBT7cjH1gddjo+M77ffkVgOLmaw3sKk29FmJ+0pYACw0xqW4ML6fuv
         ChoCYpyb8oPNiX74NqFGuXqUea/j6qKi2EX36F7RYEIpBcFLGA2aOsnVPTwPMiKW+jMg
         V2i626+HQfzM5c1b0hQ2ooAbOy2kgk7iemJmw=
Message-ID: <84144f020812191205l2b147af4m550a80e32e1efb31@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:05:21 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 03/14] kmemleak: Add the slab memory allocation/freeing hooks
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081219181313.7778.67533.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181313.7778.67533.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 743c41c5bd59586d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the callbacks to kmemleak_(alloc|free) functions from
> the slab allocator. The patch also adds the SLAB_NOLEAKTRACE flag to
> avoid recursive calls to kmemleak when it allocates its own data
> structures.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

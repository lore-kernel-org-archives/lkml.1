Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZGJItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZGJItR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZGJItC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:49:02 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30107 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZGJItB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gGKa+JOQp7WQW63sBBKMGYu/+EpU7ZzZradTbPyHljm41DxPw+6X+WJMGyIeRXANNg
         Xs6VlNp7WNFzT0vUpbp34Gch9hnKESfgeN43+/VrCNi563hHLrCcXkp5ZhV6L2DyTCuH
         o96aeglYbCBNPBbj1baHYivmD7aR3oa1tPcR4=
Date: Fri, 10 Jul 2009 16:51:08 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/44] includecheck fix: um, helper.c
Message-ID: <20090710085108.GD6263@cr0.nay.redhat.com>
References: <1247063308.4382.12.camel@ht.satnam> <1247064950.4382.45.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247064950.4382.45.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:25:50PM +0530, Jaswinder Singh Rajput wrote:
>
>fix the following 'make includecheck' warning:
>
>  arch/um/os-Linux/helper.c: linux/limits.h is included more than once.
>
>Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>---
> arch/um/os-Linux/helper.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
>index 30860b8..b6b1096 100644
>--- a/arch/um/os-Linux/helper.c
>+++ b/arch/um/os-Linux/helper.c
>@@ -15,7 +15,6 @@
> #include "os.h"
> #include "um_malloc.h"
> #include "user.h"
>-#include <linux/limits.h>
> 
> struct helper_data {
> 	void (*pre_exec)(void*);

Definitely yes.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


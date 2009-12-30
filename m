Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbZL3GUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbZL3GUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZL3GUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:20:00 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39245 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZL3GT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:19:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JgDfG9KUMsTWFdRwQ0A2YeNbekMGZ8JvyTC3wm10YpQIKo3/+IfGlVL7O7Kzj6qzl1
         dsgw/YJl/5ZEWUCzpoOyIqrHIUH5ch5qECFXeNF8xDWPWXdLbvaJ0ooCKoo0yxYXL0GQ
         q4WQpGvJqPr1boKSk1V/w0grKDawAae2zFxTs=
Date: Tue, 29 Dec 2009 22:19:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: [PATCH] input, mouse: Change the prototype of functions in
 lifebook.c
Message-ID: <20091230061955.GI2186@core.coreip.homeip.net>
References: <b9df5fa10912282009x5d0d2de4q36ab8a1f29d5a7de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10912282009x5d0d2de4q36ab8a1f29d5a7de@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 10:09:24AM +0600, Rakib Mullick wrote:
>  When CONFIG_PM=n, then we are warned by the following warning:
> 
> drivers/input/mouse/lifebook.c:33: warning: 'lifebook_limit_serio3'
> defined but not used
> drivers/input/mouse/lifebook.c:41: warning: 'lifebook_set_6byte_proto'
> defined but not used
> 

I suppose it is CONFIG_DMI, not CONFIG_PM... In fact, we should simply
make this driver depend on CONFIG_DMI.

Thanks for reporting this.

-- 
Dmitry

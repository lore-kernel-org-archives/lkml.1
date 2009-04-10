Return-Path: <linux-kernel-owner+w=401wt.eu-S936193AbZDJMY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936193AbZDJMY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZDJMYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:24:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48971 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZDJMYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vSR2sNphfvtK/NG/MOj+nwU+TR2VfzeFEY7Ho7VNCG56pA0H8ykzo3/sNLi9O5l4Fi
         Q/g9Qw5KATnvh+qyK2jiq4b6e9u4FmGXt46CmA13FD7qETKk6LIaxcl6CNYq8r3PsiOB
         DrZT+EcPXULH4/aA8EOSpbpw21FtY4zDmwE9k=
MIME-Version: 1.0
In-Reply-To: <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
	 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
Date: Fri, 10 Apr 2009 14:24:11 +0200
Message-ID: <e2e108260904100524i7d4a366bg1ed619f4e4edaff2@mail.gmail.com>
Subject: Re: [PATCH 02/14] DRBD: lru_cache
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> The lru_cache is a fixed size cache of equal sized objects. It allows its
> users to do arbitrary transactions in case an element in the cache needs to
> be replaced. Its replacement policy is LRU.
>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
>
> ---
> diff -uNrp linux-2.6.30-rc1/drivers/block/drbd/lru_cache.h linux-2.6.30-rc1-drbd/drivers/block/drbd/lru_cache.h
> --- linux-2.6.30-rc1/drivers/block/drbd/lru_cache.h     1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.30-rc1-drbd/drivers/block/drbd/lru_cache.h        2009-03-26 15:55:39.595134000 +0100
> @@ -0,0 +1,116 @@
> +/*
> +   lru_cache.c

A minor remark: I assume the above line should read "lru_cache.h"
instead of "lru_cache.c" ?

Bart.

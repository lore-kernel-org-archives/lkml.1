Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0BLBwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:52:45 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:62998 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0BLBwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:52:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PK7iRBBrBePp5mNcQ4g7iQP2c+kBiQ6KsEJyfX59g1eLM/B95/vhnRkCIuixG+VplV
         7eVRa5KuNuF8YUhwVJhaLDdR4KE4VAkSaJVGLbz6xj4aINBesKOm1r94DucFNyuoUDpr
         hwGWAraLmDKXxJXDahCZphdv5eKOyx8BudC6c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Date: Thu, 11 Feb 2010 17:52:41 -0800
Message-ID: <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
Subject: Re: Linux mdadm superblock question.
From: Michael Evans <mjevans1983@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> I may be converting a host to ext4 and was curious, is 0.90 still the only
> superblock version for mdadm/raid-1 that you can boot from without having to
> create an initrd/etc?
>
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot volume
> < 2TB?
>
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You need the superblock at the end of the partition:  If you read the
manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
NOT 1.2; those use the same superblock layout but different
locations).

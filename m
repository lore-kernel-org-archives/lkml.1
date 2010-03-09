Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0CIXx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:53:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41413 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0CIXxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LiBZoI/U3Mkcl3xBlGH+z7TsKw6yhA4KD86tBTbQse9H3amMbd3Ba/wuBdJg10Mkl6
         w3n4ULTkiadKkK7E7/WOfKwTuDGsvbfQySw0m8eRe148krceIXAbdKE1O7kt19mLdKQV
         8I9ew7prRu+YXN+3CnRd0LiNIKtL3EgEcetpo=
MIME-Version: 1.0
In-Reply-To: <1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-2-git-send-email-johnstul@us.ibm.com> <1267675049-12337-3-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-4-git-send-email-johnstul@us.ibm.com> <1267675049-12337-5-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-6-git-send-email-johnstul@us.ibm.com> <1267675049-12337-7-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-8-git-send-email-johnstul@us.ibm.com> <1267675049-12337-9-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 18:53:04 -0500
Message-ID: <8bd0f97a1003091553j1f88ef69m748bf1ef54371c2f@mail.gmail.com>
Subject: Re: [PATCH 09/14] blackfin: Convert blackfin to use 
	read/update_persistent_clock
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 22:57, John Stultz wrote:
> This patch converts the blackfin architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.
>
> I have not built or tested this patch, so help from arch maintainers would be appreciated.

Blackfin builds & boots with generic clockevents and w/out
Acked-by: Mike Frysinger <vapier@gentoo.org>

did you want me to merge it for 2.6.35 or should it go through with
your patchset ?
-mike

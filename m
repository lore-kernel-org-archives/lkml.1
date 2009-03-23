Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZCWDVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZCWDVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 23:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZCWDVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 23:21:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:20726 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbZCWDVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 23:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eKFD75F1Ays8/D1JkN+MAfxaPV4WYtyVEhNZy44rPeQ5Y9NlykocpKaxpZXKDVkJ2+
         6KpA7dH8nCiR9cPErAKF8boZY6juPVkwfws2vpOvxHLjUculifNhX0uQjTgNrMKxcB6h
         Y7Uxj4r3egKqL8bwIDN8GgyONHe9tPuB+niQE=
MIME-Version: 1.0
In-Reply-To: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
Date: Sun, 22 Mar 2009 23:21:07 -0400
Message-ID: <3e8340490903222021q24fc95e5hf1f216c69582954@mail.gmail.com>
Subject: Re: Test some kernel feature without recompile
From: Bryan Donlan <bdonlan@gmail.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 6:43 AM, Dragoslav Zaric
<dragoslav.zaric.kd@gmail.com> wrote:
> Hi,
>
> I know when you work on some kernel module, you can change code and load
> module again and test it, but what if you change some built in kernel
> .c file, why
> would I need to recompile whole kernel just to see what happens if I change one
> .c file ??
>
> Why can I just compile one changed .c file and copy it where compiled version of
> that file reside inside kernel tree? Or maybe there is some image info embedded
> inside compiled files, so that file must belong to specific image from
> which it is
> installed ?

ksplice can do this in some limited cases: http://www.ksplice.com/example-update

Obviously, changes which affect the structure of kernel datastructures
are more difficult to accomplish...

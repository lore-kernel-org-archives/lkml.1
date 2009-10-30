Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZJ3AgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZJ3AgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZJ3AgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:36:19 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36421 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZJ3AgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S/9B/LAFAmoJPkDPt7K672pVLcTjrFCtJZcfeKq0Udf1vcINdvFF1YuxyYCawAVk0V
         jx/HwTBkQ19vP3n0NG0bBbMm5LhS5LxbE1DMihaO8Q2WariNvrKR2JYgP8p8TBPqEKM9
         b1OvRg/8P6u7bhkrN5lK+XPLra02Ks2iSw01U=
MIME-Version: 1.0
In-Reply-To: <962b2e4e-74f1-47ea-8847-e16edeef151b@VA3EHSMHS013.ehs.local>
References: <962b2e4e-74f1-47ea-8847-e16edeef151b@VA3EHSMHS013.ehs.local>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 29 Oct 2009 20:36:03 -0400
Message-ID: <8bd0f97a0910291736m24f20c7ep27027691492a4bcb@mail.gmail.com>
Subject: Re: virtual vs physical addresses to cache functions
To: John Linn <John.Linn@xilinx.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 12:26, John Linn wrote:
> Maybe this is a dumb question...

you should see the stuff people put into hardware ...

> I believe that the kernel expects virtual addresses to be passed to the
> defined cache functions across all architectures.

i believe they're virtual since most (sane) hardware virtual memory
implementations are done with caches based on virtual addresses, but
what do i know (leading into next point ...)

> Looking at PowerPC and Blackfin confirm this I think.

the Blackfin arch (which is what i work on) is a bad example as it
lacks virtual memory support
-mike

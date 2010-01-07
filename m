Return-Path: <linux-kernel-owner+w=401wt.eu-S933002Ab0AGDre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab0AGDre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746Ab0AGDrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:47:33 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:48422 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab0AGDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ONAD4R7OfG91m70Nn6vDcvf49f6AfVeojSC9FBkUxAfH/1sX9oxlGLQ2kRZT8CbdJU
         u5EvegqvKbqPIr+22xSzz8DFCNkivKHbyu1EnYg5X+E5p/9/z1MxQPqkFj0tea4oZjyN
         Hw8nIHSYCZM1tfYfWOJ6F7f3/52LeV0OsRffY=
MIME-Version: 1.0
In-Reply-To: <1262136345.8733.36.camel@ICE-BOX>
References: <1262136345.8733.36.camel@ICE-BOX>
Date: Thu, 7 Jan 2010 13:47:31 +1000
Message-ID: <21d7e9971001061947i210908br839b7633a1c0fad3@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/radeon_cp.c: fix resource leak on error
From: Dave Airlie <airlied@gmail.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:25 AM, Darren Jenkins
<darrenrjenkins@gmail.com> wrote:
> If drm_addmap() fails master_priv is leaked.
>

I got a patch from Roel Kluin to fix this already, will push it out soon.

Dave.

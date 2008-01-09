Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYAIM3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYAIM3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYAIM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:28:56 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:30933 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYAIM2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hbRnob0yJeX2IjluRo26A7Oxa8/mPyGW3WOWzgL8/UJtLww7PpSmr1ToRIDJyzUblpslg4bJtg+6hsI5x+GtA+dCdAfYhePqK+tMvey4xSd1shbDt1u2S1VHXqyrzpFNw/zzUVKUx5me24jwCsY6vT+6Kmrw054LWH9weioYiWM=
Message-ID: <d1af83620801090428nd4de198ja2adbdaab48a8ead@mail.gmail.com>
Date: Wed, 9 Jan 2008 08:28:53 -0400
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Dave Airlie" <airlied@linux.ie>
Subject: Re: [patch 1/1] Convert drivers in drivers/char/drm to use .unlocked_ioctl
Cc: dri-devel@lists.sourceforge.net, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <alpine.DEB.0.82.0801090336000.9570@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109005416.039551758@gmail.com>
	 <20080109005443.227306069@gmail.com>
	 <alpine.DEB.0.82.0801090336000.9570@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 11:37 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> > The drm drivers in this patch all used drm_ioctl to perform their
> > ioctl calls.  The common function is converted to use lock_kernel()
> > and unlock_kernel() and the drivers are converted to use .unlocked_ioctl
> >
>
> NAK
>
> I've started looking at this already in the drm git tree, I'm going to
> provide both locked and unlocked paths for drivers to choose, as we need
> to audit the drivers on a per-driver basis, the other option is to provide
> wrappers in each driver to do the lock/unlock kernel and leave drm_ioctl
> alone..
>
> I'll take a look kmalloc failure case sounds like a bug though..
>

No problem.  I interpreted Andi's request for patches as a way to ensure
that people were actively working to remove the BKL from ioctl calls.
Since you appear to already have been working towards that end, the patch
is not really necessary.

-- 
Kevin Winchester

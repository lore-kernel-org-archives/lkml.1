Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYEaWvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYEaWvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYEaWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:50:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYEaWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lR56S0UwNDW5RU0NhJ7hDwPsmcC3L9zfzukg1croeZMok3Y0toIEKr7Fr/VdG1qTtnlmDqhBIJ70H3QSQlFmtH1UhpvLw57zMf3drru4bmrmHuhMpS7ZqhJIw3nu6R7mGSrdWfSfVTWb4DyPx0Rgw01SI4S6Wps/H9Oq2hX23tM=
Message-ID: <21d7e9970805311550r182c5291ta4c55e8069e631a1@mail.gmail.com>
Date: Sun, 1 Jun 2008 08:50:39 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: via agp patches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080531003214.GA6208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080531003214.GA6208@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 10:32 AM, Greg KH <gregkh@suse.de> wrote:
> Recently VIA has been distributing some pre-build kernel modules for
> their latest video cards without the source for it.  So I asked, and got
> the patches.  I've forward ported them to the current 2.6.26-rc4 tree,
> and they also apply cleanly to 2.6.25 as well.  They are here in the
> three emails after this one.
>
> I'm still working on getting some more information on exactly what these
> patches each do for a good changelog, but until then, if anyone has the
> hardware and wants to play with the code, here it is.
>
> If anyone has any questions, please let me know.
>

Like I can pull the cleanups and style one no problems, but really any
functional changes
need to be explained with some detail, and the drm changes need to be
submitted to dri-devel@lists.sf.net
and Thomas Hellstrom would need to at least understand them before we
could let them into the kernel.

also adding support to the kernel without some idea of what userspace
can use it isn't going to happen.

VIA need to deal with the openchrome project to get those sort of
changes into an upstream X.org related driver.

Dave.

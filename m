Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXA2AjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXA2AjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbXA2AjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:39:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbXA2AjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oT6mMN+ZDKKjOPhu9RZnm4TBdTvVVQGlWrBM7xiCriS7Jco+XWjbU6p/b8l+COiMtQE5SKDxxpQwhdmJMQ+6GpsPjgLYLz+ShMgh33A6dqoe540Q1YLaBr8MGocxj8mTrSG1Ir54Hkj6UvStOGNDCVH9xWoEHdz9f3BdG2yUNQc=
Message-ID: <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
Date: Mon, 29 Jan 2007 11:39:16 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: linux-fbdev-devel@lists.sourceforge.net,
       "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070128162907.370f5476.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Because most users won't even be aware of the module option: they'll just
> > > know that their card doesn't work right.
> >
> > This isn't a card problem this is a monitor problem, the card just
> > passes through the edid data from the monitor... or else the
> > programming of the card registers from edid is wrong..
>
> In which case the same problem would occur with different video cards, so
> this patch should be some generic thing, available to all drivers, no?
>

It should be in the fb layer not card specific.. as it may happen on any card...

Dave.

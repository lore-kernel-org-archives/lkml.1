Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbXE3WIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbXE3WIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbXE3WHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:07:52 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:28643 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbXE3WHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qlqer54c/PRQH7flVFPKVSbS2aLc9Dge3YZq2mMLZcqGvNwtpxNclYbpRAGED1WLSkdla5lbVuXH8/O0VrYQ9SAfvQFZMd9lHLbWDNn34UTGLmg3ASGaBOaOAOCAaSQYe9Z+5TpnHRebuFcTtUTTKVAE7HcuboOEkyCKjyikt3o=
Message-ID: <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
Date: Thu, 31 May 2007 08:07:45 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: GFP_DMA32 and PAE x86 machines
Cc: "Linus Torvalds" <torvalds@osdl.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465DECD7.8030104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>
	 <465DECD7.8030104@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on split all lowmem is below 1GB which isn't exactly
optimal, I'd llike all 4GB for DMA.

Dave.

On 5/31/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Dave Airlie wrote:
> > Just a question,
> >
> > So we have GFP_DMA32 on x86-64 to gives us memory below 4G? so we not
> > have the same on PAE based x86 machines so I can use a consistent API
> > from the drm?
> >
> > Otherwise it'll be stick some ifdefs in the drm to deal with it..
> >
>
> Well, all lowmem is below 4 GB on i386...
>
> 	-hpa
>

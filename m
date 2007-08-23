Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbXHWJcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbXHWJcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXHWJcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:32:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39399 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711AbXHWJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:32:16 -0400
Date: Thu, 23 Aug 2007 02:26:04 -0700
From: Greg KH <greg@kroah.com>
To: Richard MUSIL <richard.musil@st.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h)
Message-ID: <20070823092604.GA6057@kroah.com>
References: <46CD497F.8030207@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD497F.8030207@st.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 10:46:55AM +0200, Richard MUSIL wrote:
> Dear all,
> 
> I am currently writing virtual TPM device driver. This driver exposes
> itself and behaves like regular TPM device (i.e. uses TPM layer which is
> already present in kernel), but instead of talking to hardware it talks
> to user space.

Heh, I like the idea, I can imagine what it could be used for :)

> What I present below is rather quickfix with least impact on other TPM
> parts (drivers). The patch uses device->remove callback (of
> platform_device device) and reroutes this to itself. In this
> callback it eventually calls vendor callback and finally kfrees all
> memory resources allocated on its own.

It looks sane to me, nice fixup.

thanks,

greg k-h

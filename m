Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbYHDTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbYHDTtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYHDTt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:49:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbYHDTt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:49:26 -0400
Date: Mon, 4 Aug 2008 12:46:30 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: stable@kernel.org, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] Ath5k: fix memory corruption
Message-ID: <20080804194630.GA26971@kroah.com>
References: <1217842628-22714-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217842628-22714-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 11:37:07AM +0200, Jiri Slaby wrote:
> Please consider these two patches for including in -stable.
> 3a0f2c871849f23c1070965bf94dec3f9c0b479d
> 10488f8ad62be3b860bad74e60b4fe6ab87aece3
> Both attached (1 per email).
> 
> The issue fixed by the first patch is triggerable on noisy channels,
> so it's a real problem.
> 
> The issue fixed by the second patch triggers often by loading and
> reloading the driver repeatedly, it's not hypothetical too.

Are either of these patches also relevant for the 2.6.25 tree?  It seems
like the second one will apply, but I don't know if the logic is correct
for me to force that.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbXEQWrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbXEQWrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbXEQWro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:47:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:4174 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEQWro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:47:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229295619"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] allow console unregistration
Date: Thu, 17 May 2007 15:47:33 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com> <200705171532.28799.jesse.barnes@intel.com>
In-Reply-To: <200705171532.28799.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171547.33377.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007 3:32 pm Jesse Barnes wrote:
> Randy just informed me that the patch limits are bigger now, so here
> are the actual patches.
>
> This patch allows for proper console unregistration via the VT layer,
> and updates the FB layer to use it.  This makes debugging new console
> drivers much easier, since you can properly clean them up before
> unloading. Antonio already checked it out (and suggested a tweak for
> the fbcon side) so I think it's on its way already via the FB tree.

And before someone complains, here's the diffstat:
 drivers/char/vt.c             |   21 +++++++++++++++++++--
 drivers/video/console/fbcon.c |   17 ++++++++++++++++-
 drivers/video/fbmem.c         |    2 ++
 include/linux/console.h       |    1 +
 include/linux/fb.h            |    2 ++
 5 files changed, 40 insertions(+), 3 deletions(-)

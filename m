Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXE3AAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXE3AAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXE3AAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:00:42 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:26306 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXE3AAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mCGdHDhzYuwZSKkNq3blQ1GKbzxsAsFUqZgdnHD/C5mWGuEsWGkrXFAPqeOdKpDPetAU7eyTdQIrthKUa3oprFKFhZHEisAOXZoUPrV3szlrroaSNYN/AJO2EPELpVHNbrCmWbZ0LUmZ5Ds2wQTKvNEOe0Y1iYbOeA2tyTSD1x8=
Subject: Re: [PATCH 1/3] allow console unregistration
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       Jakob Bornecrantz <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net,
       "Geert.Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <200705171532.28799.jesse.barnes@intel.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705171532.28799.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 08:00:32 +0800
Message-Id: <1180483232.10390.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> Randy just informed me that the patch limits are bigger now, so here are the
> actual patches.
> 
> This patch allows for proper console unregistration via the VT layer, and
> updates the FB layer to use it.  This makes debugging new console drivers
> much easier, since you can properly clean them up before unloading.
> Antonio already checked it out (and suggested a tweak for the fbcon side)
> so I think it's on its way already via the FB tree.
> 

Jesse,

I already implemented (and tested) selective framebuffer/console
unregistration in my tree using your patch as a base. I'll send this
patch to akpm soon.

Geert,

Is this something that you might need for ps3fb? It should address 2 of
your concerns. The only thing is that you will need
CONFIG_VT_HW_CONSOLE_BINDING=y.  You can default this to 'y' in your
platform, or select it.

Tony


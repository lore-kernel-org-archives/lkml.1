Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZB0AhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZB0AhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbZB0Agw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:36:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:15398 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZB0Agv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WP+wRBsRVjj+SB9DXA04t3g1Z9BjXvSGHbtMsfCvTrDq7I4mJI6tPeSVSw5CPAl6u5
         2WyQCFaz2Kb3mC6SN9y6KYdiuG8H72BZ6HWGlBeu/OJstZu9+nSvssnfy1omDOv6pUa7
         frnCr/nuE2roSvx5/33Ct/5ps5cRuUbnvod0g=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902262119570.5238@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
	 <Pine.LNX.4.64.0901162048400.9060@axis700.grange>
	 <4974F208.3020407@intel.com>
	 <Pine.LNX.4.64.0901201048090.5126@axis700.grange>
	 <Pine.LNX.4.64.0902191533090.5156@axis700.grange>
	 <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
	 <e9c3a7c20902251354x5512c222h41c2c9ebfa290e0b@mail.gmail.com>
	 <Pine.LNX.4.64.0902260833001.5238@axis700.grange>
	 <e9c3a7c20902261041t7e483c24m1151b89d79b5f718@mail.gmail.com>
	 <Pine.LNX.4.64.0902262119570.5238@axis700.grange>
Date: Thu, 26 Feb 2009 17:36:48 -0700
X-Google-Sender-Auth: efdadd8719fe2887
Message-ID: <e9c3a7c20902261636u7bea73f3j33d270b787779bdd@mail.gmail.com>
Subject: Re: [PATCH 3/4 v9] i.MX31: framebuffer driver
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 1:34 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> From: Guennadi Liakhovetski <lg@denx.de>
>
> This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
> displays, vertical panning supported, no overlay support.
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---

Thanks,

I'll queue the following branch to -next:

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git imx-fb-fix

Dan Williams (1):
      Revert "i.MX31: framebuffer driver"

Guennadi Liakhovetski (1):
      i.MX31: framebuffer driver

 arch/arm/plat-mxc/include/mach/mx3fb.h |   26 +-
 drivers/video/Kconfig                  |   20 +-
 drivers/video/Makefile                 |    2 +-
 drivers/video/mx3fb.c                  | 2300 ++++++++++++++++----------------
 4 files changed, 1174 insertions(+), 1174 deletions(-)

--
Dan

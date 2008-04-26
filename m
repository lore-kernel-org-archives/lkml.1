Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYDZQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYDZQIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYDZQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:08:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:7165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYDZQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ciwpZ0shYeKekyruA9y9+qOAn9t4apy4njUZJFRNJ60uvJr8/2LMRGTlH4Aet5MLUptlgzlPux460xVcvXusRZuQVay72ddti5LRKRX3EOKq70Ea9iCIv6t9i2hxwmsxXYUYEpZG2mxBOJ9HX6NC78J2ccrOS44qqq44cC63kLo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch] latest git: DEV_BLK_4DRIVES should be a tristate
Date: Sat, 26 Apr 2008 14:47:04 +0200
User-Agent: KMail/1.9.9
Cc: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org
References: <20080424150717.GA32700@slug> <20080424192403.GB18854@cs181133002.pp.htv.fi>
In-Reply-To: <20080424192403.GB18854@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804261447.05147.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Adrian Bunk wrote:
> On Thu, Apr 24, 2008 at 05:07:17PM +0200, Frederik Deweerdt wrote:
> > Hello Bartlomiej,
> > 
> > The 4drives should be a tristate, the following breakage occurs
> > otherwise:
> > ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!
> >...
> 
> "ide: remove obsoleted "idex=" kernel parameters" will already fix this 
> breakage.
> 
> Bart, can you push this patch?

I applied Frederik's fix ("ide: remove obsoleted "idex=" kernel parameters"
depends on some other patches that need to pushed first).

Thanks,
Bart

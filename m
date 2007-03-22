Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbXCVSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbXCVSnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934184AbXCVSnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:43:41 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:11573 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934181AbXCVSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MEFWZkH306MyBl/P6tTtUDULIFZc/H02qqwVc41R2TvI9Yv7YCuXrWT8Ypd46txu90rUa3n5M4GARpyqu4xxNw/0O612B/9PJMI8+qL0+/fbE2ywY5qzvSFxJ3k6t+xKAZKT5jJEuxUps+7j9BfVdk/v/P05eyDCaJu+ZrQrXd8=
Date: Thu, 22 Mar 2007 14:43:35 -0400
From: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
To: linux@horizon.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Message-ID: <20070322184335.GB31733@cathedrallabs.org>
References: <20070322123821.7843.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322123821.7843.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a uniprocessor AMD64 system running software RAID-5 and RAID-10
> over multiple PCIe SiI3132 SATA controllers.  The hardware has been very
> stable for a long time, but has been acting up of late since I upgraded
> to 2.6.20.3.  ECC memory should preclude the possibility of bit-flip
> errors.
Tried checking the memory with memtest86?

Do you have k8_edac module loaded?
If you don't, I'd recomend using it to get reports of
recoverable/unrecoverable memory errors, check http://bluesmoke.sf.net/ for
latest version.

-- 
Aristeu


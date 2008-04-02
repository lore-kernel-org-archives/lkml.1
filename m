Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYDBFET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYDBFET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 01:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYDBFEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 01:04:09 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:13199 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYDBFEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 01:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bkfVZbovwZ+hxYtn28Z2KBJ5Izdi94Ts8xAtjgTM17dupWWLF94fziJUuX4zT1xKLb6ePBvfevc8gaXzTrpDTrZOsq3OykKVlLsFsIQQ5fus3UQ+7D8FR2Iha9hm08mjDn2mPFe256PzWtan98/++/WEqt+4mqGmi1YF/C7rIX8=
Date: Wed, 2 Apr 2008 01:04:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: Re: [PATCH 6/6] Build system and MAINTAINERS entry for WM97xx
	touchscreen drivers
Message-ID: <20080402050400.GA14189@anvil.corenet.prv>
References: <20080401102825.GA30868@rakim.wolfsonmicro.main> <1207046169-2152-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1207046169-2152-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1207046169-2152-3-git-send-email-broonie@opensource.wolfsonmicro.com> <1207046169-2152-4-git-send-email-broonie@opensource.wolfsonmicro.com> <1207046169-2152-5-git-send-email-broonie@opensource.wolfsonmicro.com> <1207046169-2152-6-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207046169-2152-6-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Apr 01, 2008 at 11:36:09AM +0100, Mark Brown wrote:
> +config TOUCHSCREEN_WM9705
> +	bool "WM9705 Touchscreen interface support"
> +	depends on TOUCHSCREEN_WM97XX
> +	help
> +	  Say Y here if you have a Wolfson Microelectronics WM9705 touchscreen
> +	  controller connected to your system.
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called wm9705.

This is not correct. The chip drivers are compiled into wm97xx-ts
module, there is no wm9705 module. I fixed it on my side and
applied the series to wm97xx branch of my input tree. I also moved
changes to Makefile/Kconfig to the appropriate patches instead of
doing bulk update as a separate patch. Please take a look and let
me know if you see anything wrong.

Thank you.


-- 
Dmitry

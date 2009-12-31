Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZLaN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZLaN0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 08:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZLaN0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 08:26:18 -0500
Received: from centrinvest.ru ([94.25.115.130]:48898 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZLaN0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 08:26:17 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Dec 2009 08:26:17 EST
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Thu, 31 Dec 2009 16:18:52 +0300
To: Peter Paul <abnominales@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BCM70010 (crystalhd) Linux Driver
Message-ID: <20091231131852.GB32492@centrinvest.ru>
Mail-Followup-To: Peter Paul <abnominales@web.de>,
	linux-kernel@vger.kernel.org
References: <523138909@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523138909@web.de>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 364, 12 30, 2009 at 09:06:15PM +0100, Peter Paul wrote:
> Broadcom has just released a linux driver for their BCM70012 and BCM70015 Crystal HD High Definition video decoders under the GPLv2 licence. [1]
> Maybe you want to have a look at them.
> 
> [1] http://www.broadcom.com/support/crystal_hd/

>From quick inspection kernel part looks much better than most vendor-provided
drivers. It needs some cleanups and bugfixes, for example error handling in
device probe function doesn't look right to me, driver can't handle more than
one device as far as I can see (I don't know is it really needed though), etc.
But anyway this driver definitely deserves putting into staging.

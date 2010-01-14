Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067Ab0ANPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0ANPLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189Ab0ANPKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:10:33 -0500
Received: from xyzzy.farnsworth.org ([65.39.95.219]:40947 "EHLO
	xyzzy.farnsworth.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab0ANPKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:10:30 -0500
X-Greylist: delayed 1826 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 10:10:30 EST
Date: Thu, 14 Jan 2010 07:39:47 -0700
From: Dale Farnsworth <dale@farnsworth.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Message-ID: <20100114143947.GA4564@farnsworth.org>
References: <20100114113235.GA20473@linux-sh.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100114113235.GA20473@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] rtc: rtc-max6900: SMBus support.
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 08:32:35PM +0900, Paul Mundt wrote:
> The current rtc-max6900 driver only supports getting and setting the time
> through bursting, which requires a controller capable of such. As
> bursting is merely an optimization, we can also opt for the non-burst
> fallback path that pokes at the date/time registers individually.
> 
> By opting for the fallback solution, it's possible to fully support the
> RTC on controllers that only implement I2C_FUNC_SMBUS_BYTE_DATA instead
> of requiring master transfers via I2C_FUNC_I2C.
> 
> This was tested with an I2C_FUNC_SMBUS_BYTE_DATA controller with a MAX6909
> attached. Currently only a subset of the MAX6909 functionality is supported,
> patches to extend the current driver to be forthcoming.
> 
> There are no functional changes for I2C_FUNC_I2C controllers.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: Dale Farnsworth <dale@farnsworth.org>

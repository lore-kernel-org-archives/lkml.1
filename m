Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZDGBGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZDGBGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZDGBGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:06:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZDGBGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:06:09 -0400
Date: Mon, 6 Apr 2009 18:02:06 -0700
From: Greg KH <gregkh@suse.de>
To: Elina <epasheva@sierrawireless.com>
Cc: rfiler@sierrawireless.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002/003] USB: serial: sierra driver blacklisting
Message-ID: <20090407010206.GC2839@suse.de>
References: <1239062758.10120.37.camel@Linuxdev3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239062758.10120.37.camel@Linuxdev3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:05:58PM -0700, Elina wrote:
> Subject: [PATCH 002/003] USB: serial: sierra driver blacklisting
> From: Elina Pasheva <epasheva@sierrawireless.com>﻿
> 
> The series of 3 patches modify sierra usb serial driver with
> blacklisting of specific non-serial interfaces, bug fixing and
> performance improvements.
> This is [PATCH 002/003]. This patch depends on [PATCH 001/003].
> ﻿The following is summary of changes we have made to sierra.c driver in
> [PATCH 02/03] dealing with blacklisting:
> ﻿- Added blacklist for specific non-serial interfaces.
> - Removed potential kernel oops from sierra_calc_num_ports() function.
> Calling this function twice would likely have caused an oops because the
> function releases allocated memory after the first call.
> - Modified sierra_probe() function to reflect the changes in
> sierra_calc_num_ports().

Please split this up into the 3 different patches here.

thanks,

greg k-h

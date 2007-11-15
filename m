Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXKOQNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXKOQNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXKOQNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:13:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442AbXKOQNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:13:17 -0500
Message-ID: <473C6FCF.6010501@redhat.com>
Date: Thu, 15 Nov 2007 11:11:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: [patch 04/13] param_sysfs_builtin memchr argument fix
References: <20071115042610.731859958@mini.kroah.org> <20071115060927.GE7602@kroah.com>
In-Reply-To: <20071115060927.GE7602@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2007 01:09 AM, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Dave Young <hidave.darkstar@gmail.com>
> 
> patch faf8c714f4508207a9c81cc94dafc76ed6680b44 in mainline.
> 
> If memchr argument is longer than strlen(kp->name), there will be some
> weird result.
> 
> It will casuse duplicate filenames in sysfs for the "nousb".  kernel
> warning messages are as bellow:
> 

Needs an additional fix:

Commit:     22800a2830ec07e7cc5c837999890ac47cc7f5de
fix param_sysfs_builtin name length check

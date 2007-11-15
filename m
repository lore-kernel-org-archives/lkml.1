Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbXKOPv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbXKOPv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXKOPvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:51:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbXKOPvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:51:19 -0500
Message-ID: <473C6AAF.5020901@redhat.com>
Date: Thu, 15 Nov 2007 10:50:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 20/40] USB: remove USB_QUIRK_NO_AUTOSUSPEND
References: <20071115062710.885284510@mini.kroah.org> <20071115064457.GU19218@kroah.com>
In-Reply-To: <20071115064457.GU19218@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2007 01:44 AM, Greg Kroah-Hartman wrote:
> 
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> patch a691efa9888e71232dfb4088fb8a8304ffc7b0f9 in mainline.
> 
> This patch (as995) cleans up the remains of the former NO_AUTOSUSPEND
> quirk.  Since autosuspend is disabled by default, we will let
> userspace worry about which devices can safely be suspended.  Thus the

How is it disabled by default? I still see a default timeout of 2 in
the code before this patch is applied.




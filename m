Return-Path: <linux-kernel-owner+w=401wt.eu-S969392AbXFHROJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969392AbXFHROJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967192AbXFHRNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:13:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761169AbXFHRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:13:52 -0400
Message-ID: <46698941.5030200@redhat.com>
Date: Fri, 08 Jun 2007 12:52:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>,
       Roland Scheidegger <sroland@tungstengraphics.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 16/54] Input: i8042 - fix AUX port detection with some
 chips
References: <20070608072127.352723000@sous-sol.org> <20070608072158.875539000@sous-sol.org>
In-Reply-To: <20070608072158.875539000@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2007 03:21 AM, Chris Wright wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Roland Scheidegger <sroland@tungstengraphics.com>
> 
> The i8042 driver fails detection of the AUX port with some chips,
> because they apparently do not change the I8042_CTR_AUXDIS bit
> immediately. This is known to affect at least HP500/HP510 notebooks,
> consequently the built-in touchpad will not work. The patch will simply
> reread the value until it gets the expected value or a retry limit is
> hit, without touching other workaround code in the same area.
> 
> Signed-off-by: Roland Scheidegger <sroland@tungstengraphics.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=d2ada5597d33a9108acb2caf912f85cbc9caab1e
> 

Also needed for 2.6.20.


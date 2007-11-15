Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXKOMY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXKOMY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXKOMYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:24:51 -0500
Received: from zakalwe.fi ([80.83.5.154]:39315 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbXKOMYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:24:50 -0500
Date: Thu, 15 Nov 2007 14:24:48 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       shemminger@linux-foundation.org
Subject: Re: [patch 00/16] 2.6.23-stable review, network driver changes
Message-ID: <20071115122448.GK8865@zakalwe.fi>
References: <20071115063921.GA18827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:39:21PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.23.X release.
> There are 16 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.
> ...
>  drivers/net/skge.c                     |  141 +++++++++++++++++----------------
>  drivers/net/skge.h                     |    6 -

I found a regression when I applied drivers/net/skge.[ch] patches on top 
of 2.6.23.1 at stable tree (4367388f04eea72e78347dc9b299698bf4275f92). 
It hangs the network on high speed transfers.

This the same regression that happened for 2.6.24-rc*:

	http://bugzilla.kernel.org/show_bug.cgi?id=9321

The driver in 2.6.23.1 works for me. Afaik, Stephen Hemminger is working 
on it.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd

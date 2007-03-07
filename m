Return-Path: <linux-kernel-owner+w=401wt.eu-S2992436AbXCGSUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992436AbXCGSUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992438AbXCGSUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:20:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992436AbXCGSUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:20:01 -0500
Date: Wed, 7 Mar 2007 10:14:44 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org, thomas@archlinux.org,
       val_henson@linux.intel.com, samuel.thibault@ens-lyon.org
Subject: Re: [patch 097/101] revert "drivers/net/tulip/dmfe: support basic
 carrier detection"
Message-ID: <20070307101444.52cb2146@freekitty>
In-Reply-To: <20070307171657.461008445@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
	<20070307171657.461008445@mini.kroah.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 09:12:12 -0800
Greg KH <gregkh@suse.de> wrote:

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Revert 7628b0a8c01a02966d2228bdf741ddedb128e8f8.  Thomas Bachler
> reports:
> 
>   Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
>   support basic carrier detection) breaks networking on my Davicom DM9009. 
>   ethtool always reports there is no link.  tcpdump shows incoming packets,
>   but TX is disabled.  Reverting the above patch fixes the problem.
> 

Carrier detection support is important and should be fixed rather than removed.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

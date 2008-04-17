Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYDQHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYDQHxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYDQHxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:53:05 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53255 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYDQHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:53:04 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint requirements.
Date: Thu, 17 Apr 2008 10:01:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Spanton <rspanton@zepler.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20080417010122.148289106@sous-sol.org> <20080417010337.278890290@sous-sol.org>
In-Reply-To: <20080417010337.278890290@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804171001.59496.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. April 2008 03:01:46 schrieb Chris Wright:
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Robert Spanton <rspanton@zepler.net>
> 
> upstream commit: 1bfd6693cd66f1e79abce62d3e8c3647e1f59a55
> 
> The changes introduced in commit
> 063a2da8f01806906f7d7b1a1424b9afddebc443 changed the semantics of the
> num_interrupt_in, num_interrupt_out, num_bulk_in and num_bulk_out
> entries of the usb_serial_driver struct to be the number of endpoints
> the device has when probed.

Greg, your last patch to 2.6.25-rc9 should have obsoleted this patch.
Should your patch be included instead of this patch and
"USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24" ?

	Regards
		Oliver

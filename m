Return-Path: <linux-kernel-owner+w=401wt.eu-S1030946AbXDVPlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030946AbXDVPlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030948AbXDVPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:41:53 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:52368 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030946AbXDVPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:41:52 -0400
Date: Sun, 22 Apr 2007 11:41:51 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070422154151.GJ5575@csclub.uwaterloo.ca>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com> <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com> <20070414192807.60bdf84b@hyperion.delvare> <20070418174256.GB5577@csclub.uwaterloo.ca> <20070419085413.1520feef@hyperion.delvare> <20070419205942.GC5577@csclub.uwaterloo.ca> <20070420194933.0813a359@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420194933.0813a359@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 07:49:33PM +0200, Jean Delvare wrote:
> The scx200_acb driver was heavily modified in 2.6.17 and 2.6.18, not
> much since then. I am not familiar with the hardware so I can't comment
> on which chips are supposed to work and which aren't.

Well 2.6.18's scx200_acb works on the geode LX module I have, but no on
the geode sc1200 module (where scx200_i2c does work).

scx200_acb doesn't detect any device that it can drive (nothing in dmesg
at all when loaded) on the sc1200.  I believe the main changes that
happened to scx200_acb was adding support for the newer CSxxxx chipsets,
such as the one used with the geode LX (which does work now).

--
Len Sorensen

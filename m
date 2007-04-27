Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXD0OT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXD0OT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXD0OTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:19:51 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:41357 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875AbXD0OTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:19:21 -0400
Date: Fri, 27 Apr 2007 10:19:20 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070427141920.GF5577@csclub.uwaterloo.ca>
References: <20070419205942.GC5577@csclub.uwaterloo.ca> <20070420194933.0813a359@hyperion.delvare> <20070422154151.GJ5575@csclub.uwaterloo.ca> <20070423114254.71787844@hyperion.delvare> <20070423144710.GD1372@cosmic.amd.com> <20070426145634.3ac2b7a3@hyperion.delvare> <20070426132905.GP5575@csclub.uwaterloo.ca> <20070426133920.GA25456@cosmic.amd.com> <20070426140323.GE5577@csclub.uwaterloo.ca> <20070427100204.403d068c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427100204.403d068c@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:02:04AM +0200, Jean Delvare wrote:
> I suspect that Jordan meant that there is no LPC either. In which case,
> of course, there's no way scx200_acb will ever work on that system, and
> GPIO-based bitbanging is the way to go. Just using i2c-gpio rather than
> scx200_i2c.

Ehm, there most certainly is LPC on a Geode LX800 + CS5536.  I am
currently using the LPC bus on it, and scx200_acb in 2.6.18 works
perfectly with the I2C on it too.

--
Len Sorensen

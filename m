Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXD0IB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXD0IB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXD0IB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:01:29 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1953 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755471AbXD0IB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:01:28 -0400
Date: Fri, 27 Apr 2007 10:02:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070427100204.403d068c@hyperion.delvare>
In-Reply-To: <20070426140323.GE5577@csclub.uwaterloo.ca>
References: <20070418174256.GB5577@csclub.uwaterloo.ca>
	<20070419085413.1520feef@hyperion.delvare>
	<20070419205942.GC5577@csclub.uwaterloo.ca>
	<20070420194933.0813a359@hyperion.delvare>
	<20070422154151.GJ5575@csclub.uwaterloo.ca>
	<20070423114254.71787844@hyperion.delvare>
	<20070423144710.GD1372@cosmic.amd.com>
	<20070426145634.3ac2b7a3@hyperion.delvare>
	<20070426132905.GP5575@csclub.uwaterloo.ca>
	<20070426133920.GA25456@cosmic.amd.com>
	<20070426140323.GE5577@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 10:03:23 -0400, Lennart Sorensen wrote:
> On Thu, Apr 26, 2007 at 07:39:20AM -0600, Jordan Crouse wrote:
> > There is no ISA on the LX.
> 
> Isn't LPC a good equivalant?

I suspect that Jordan meant that there is no LPC either. In which case,
of course, there's no way scx200_acb will ever work on that system, and
GPIO-based bitbanging is the way to go. Just using i2c-gpio rather than
scx200_i2c.

-- 
Jean Delvare

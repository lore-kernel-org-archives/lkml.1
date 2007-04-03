Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbXDCAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbXDCAv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXDCAv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:51:58 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:59362 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846AbXDCAv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:51:58 -0400
Date: Tue, 3 Apr 2007 10:51:56 +1000
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Powerpc build unhappy in 2.6.20.4?
Message-ID: <20070403005156.GN12768@bakeyournoodle.com>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	linux-kernel@vger.kernel.org
References: <200703301753.27379.rob@landley.net> <20070401231440.GK12768@bakeyournoodle.com> <200704021514.14681.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704021514.14681.rob@landley.net>
User-Agent: Mutt/1.5.9i
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 03:14:14PM -0400, Rob Landley wrote:
 
> Sure, quite easily the source of the trouble.  Attached in both full .config 
> and mini.config formats.

Okay, I have no idea how it happend but you seem to have an invalid
config.  It looks to me like you need to select a platform.

One of the following:
	CONFIG_PPC_PSERIES
	CONFIG_PPC_MAPLE
	CONFIG_PPC_IBM_CELL_BLADE
	CONFIG_PPC_PS3
	CONFIG_PPC_CHRP
	CONFIG_PPC_EFIKA
	CONFIG_PPC_PMAC

When did this config last build a zImage?  I'm guessing either CHRP or
PMAC?

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!


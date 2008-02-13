Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbYBMVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbYBMVYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYBMVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:24:29 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:54009 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbYBMVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:24:17 -0500
Date: Thu, 14 Feb 2008 00:24:22 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Bob Tracy <rct@frus.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
Message-ID: <20080213212422.GB2853@jurassic.park.msu.ru>
References: <20080213155713.GA376@jurassic.park.msu.ru> <20080213171443.80C8BDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213171443.80C8BDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:14:43AM -0600, Bob Tracy wrote:
> Ivan Kokshaysky wrote:
> > No SMP, no PRINTK_TIMESTAMPS in my case. Looks like it dies trying to
> > to switch to vga console, but I had no time to debug this yet...
> 
> Same basic configuration as Ivan.  Concur with the observation that
> death seems to happen during the console switch.  Using the radeonfb
> driver (built-in, default graphics mode 80x30).

As Peter pointed out in other mail, this is fixed by

http://lkml.org/lkml/2008/1/28/100

Ivan.

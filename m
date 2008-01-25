Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYAYO0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYAYO0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYAYO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:26:00 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60645 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYAYOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:25:59 -0500
Date: Fri, 25 Jan 2008 09:25:59 -0500
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [resolved] kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable amd64
Message-ID: <20080125142559.GJ16171@csclub.uwaterloo.ca>
References: <4797D86B.3060202@linuxdingsda.de> <20080123170748.36068472@deepthought> <20080124144547.GB16173@csclub.uwaterloo.ca> <4799B732.2030907@linuxdingsda.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4799B732.2030907@linuxdingsda.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:17:22AM +0100, Tobias Winter wrote:
> Did so. After quite some time memtest found errors. Switching the
> module in question resolved the issue. Thanks for the great feedback :)

Often removing half the ram, running a kernel compile, see if it
segfaults, then repeat with the other half of ram is much faster and
more reliable than memtest.  memtest just doesn't have the same random
accesses while keeping the cpu underload as a kernel compile does.

Personally I just don't bother with memtest anymore.  The only thing it
tells you is that you have errors or that you might have errors but it
didn't find them.  It never tells you that you do not have errors and it
often does miss that you have errors since marginal memory is more
likely to fail under cpu load it seems which memtest doesn't do.

--
Len Sorensen

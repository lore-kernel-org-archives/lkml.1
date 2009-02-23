Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZBWWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZBWWcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZBWWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:32:33 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59848 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZBWWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:32:32 -0500
Date: Mon, 23 Feb 2009 22:32:26 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>
Cc: jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [REGRESSION] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090223223226.GA23763@silver.sucs.org>
References: <20090221153822.GA4571@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221153822.GA4571@silver.sucs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 03:38:22PM +0000, Sitsofe Wheeler wrote:
> With 2.6.29rc5 and xorg-server 2:1.4.1~git20080131-1ubuntu9.2 switching
> to a VT after starting compiz causes X to nearly lock up.
> 
> Steps to reproduce:
> 1. Start X
> 2. Run compiz
> 3. Switch to VT1 via ctrl-alt-f1
> 4. Switch back to X via ctrl-alt-f7
> 
> The result is that X will remain displaying a black screen from then on
> (the mouse cursor is visible and still moves). Switching to a VT after
> this locks up the keyboard. When compiz is not running this bug does not
> occur. I am not using kernel mode setting and booting with nomodesetting
> made no difference. This problem was not present in 2.6.28. The problem
> is reproducible every time.
> 
> Graphics card is an i915 in an EeePC 900:
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller [8086:2592] (rev 04)
> 
> This might be http://bugzilla.kernel.org/show_bug.cgi?id=12264 but I
> can't reopen that bug and this bug might turn out to be different. Might
> also be related to
> http://marc.info/?l=linux-kernel&m=123499984611624&w=2 .

Still here in 2.6.29-rc6.

-- 
Sitsofe | http://sucs.org/~sits/

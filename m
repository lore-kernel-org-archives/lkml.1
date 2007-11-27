Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbXK0Ees@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbXK0Ees (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXK0Eek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:34:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbXK0Eej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:34:39 -0500
Date: Mon, 26 Nov 2007 23:34:11 -0500
From: Dave Jones <davej@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20071127043411.GF15764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
	Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org
References: <20071125161631.GA21947@stusta.de> <20071126122706.GA5167@ucw.cz> <20547.1196135084@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20547.1196135084@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:44:44PM -0500, Valdis.Kletnieks@vt.edu wrote:
 
 > I suspect that given the "once it escapes, it's cast in stone" view we take
 > towards user-visible API/etc, there isn't much *real* room for an
 > 'EXPERIMENTAL' flag anymore.  Most of the usage should probably be confined to
 > individual drivers, where all we should need is a 'default n' and suitable
 > warning verbiage in the Kconfig file warning about the driver eating your
 > filesystems and small animals for breakfast.

Potential corruptors are usually flagged with (DANGEROUS) in the text,
(One may argue that they shouldn't have escaped -mm)

 >  We certainly shouldn't have
 > one big flag for *all* in-progress drivers - I don't need to accidentally
 > enable a busticated ethernet driver because I want a USB widget.

So no ethernet driver at all is better than a broken but mostly working one?
Again if it isn't mostly working, it shouldn't have escaped -mm

	Dave

-- 
http://www.codemonkey.org.uk

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZF2LgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZF2LgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZF2LgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:36:14 -0400
Received: from smtpq4.gn.mail.iss.as9143.net ([212.54.34.167]:33947 "EHLO
	smtpq4.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbZF2LgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:36:13 -0400
Date: Mon, 29 Jun 2009 13:36:13 +0200
From: Dick Streefland <dick@streefland.net>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090629113613.GA6853@streefland.net>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629025146.GA5998@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1MLF9i-00029Z-Ao
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.322, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60, TW_IK 0.08)
X-ZiggoSMTP-MailScanner-From: dick@streefland.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2009-06-29 10:51, Amerigo Wang wrote:
| Does this work?
| My quick test shows no...
| 
| I still can't get the right offset number with this trick.
| 
| P.S. My grep is 2.5.1.

I've tested the script with grep 2.5.1, and it works for me. Can you be
more specific about what you think is wrong with the offsets? You need
to be aware of the fact that because "tr" replaces the first character
of the pattern by a newline, an offset will be 1 higher than the start
of the original pattern. The resulting offsets are therefore 1-based
instead of 0-based, which is exactly what "tail" expects for the "-c"
option.

-- 
Dick

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYH2KXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYH2KXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYH2KXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:23:45 -0400
Received: from lazybastard.de ([212.112.238.170]:60681 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYH2KXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:23:45 -0400
Date: Fri, 29 Aug 2008 12:23:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'Bruce Leonard'" <brucle@earthlink.net>, Bruce_Leonard@selinc.com,
       linux-kernel@vger.kernel.org, Tim Anderson <tanderson@mvista.com>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Message-ID: <20080829102326.GA27647@logfs.org>
References: <1219817017.18027.149.camel@sauron> <000201c9080d$0bce0d20$6b01a8c0@mvista.com> <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk> <1219827692.7107.170.camel@pmac.infradead.org> <20080827143416.GA1371@logfs.org> <1219848463.18027.166.camel@sauron> <20080827152534.GB1371@logfs.org> <1219988887.4036.7.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1219988887.4036.7.camel@sauron>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 August 2008 08:48:07 +0300, Artem Bityutskiy wrote:
> On Wed, 2008-08-27 at 17:25 +0200, Jörn Engel wrote:
> > 
> > Could be useful, I don't mind you sending a patch.  However, does this
> > means that MEMGETINFO64 or some other ioctl should not be done?  Should
> > flash_erase open, read and close 8 seperate files instead of doing a
> > single ioctl?  And should our support for large devices wait for the
> > sysfs support that has been talked about and not done for about two
> > years already?
> 
> Up to dwmw2, but I do not mind if the answer to all the above questions
> is "yes" :-)

Well, I personally think a "yes" to the last question would be utter
madness.  Whoever answers that should better come up with an alternative
patch for sysfs support pronto.

Large flashes are not a one-off cases where a single manufacturer had a
rather bizarre design.  Their numbers will continually increase.  And
not supporting an ever-increasing class of hardware is simply not an
option.

Jörn

-- 
 on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle

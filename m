Return-Path: <linux-kernel-owner+w=401wt.eu-S936734AbYBVBq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936734AbYBVBq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762223AbYBVBqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:46:17 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36756 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761754AbYBVBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:46:15 -0500
Message-ID: <47BE2985.6020305@davidnewall.com>
Date: Fri, 22 Feb 2008 12:16:45 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>	<20080221154951.GA28328@cs181133002.pp.htv.fi>	<adahcg2awag.fsf@cisco.com>	<20080221210124.GD28328@cs181133002.pp.htv.fi>	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain>
In-Reply-To: <m3tzk1q3rt.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> I'm personally of the opinion that a lot of checkpatch "fixes" are 
>> anything but. That mainly concerns fixing overlong lines
>>     
>
> Perhaps we should increase line length limit, 132 should be fine.
> Especially useful with long printk() lines and long arithmetic
> expressions.
>   


Yes; or even longer.  80 characters might have made sense on a screen
when the alternative was 80 characters on a punched card, but on a
modern computer it's very restrictive.  That's especially true with the
deep indents that you quickly get in C.  Even short lines often need to
be split when you put a few tabs in front of them, and that makes
comprehension that bit harder, not to mention looks ugly.

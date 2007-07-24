Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXGXSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXGXSbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXGXSbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:31:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4331 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXGXSbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:31:42 -0400
Message-ID: <46A64587.2010704@shadowen.org>
Date: Tue, 24 Jul 2007 19:31:35 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org> <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 25 2007 02:22, Paul Mundt wrote:
>> Perhaps CodingStyle can start being versioned, so people can opt out of
>> certain 'improvements' whenever someone has a vision, much like some
>> nameless licenses.
> 
> I'd say Codingstyle is versioned by means of git commit IDs.
> 
>> Personally I prefer the second style, and if there's a comment block,
>> then it makes sense to complete the tree with {}'s (the keyword here is
>> prefer, as it's a personal preference). checkpatch has been quite useful
>> for catching obviously broken things, and now it seems like it's just
>> overreaching. Perhaps this functionality can be split in to a lite
>> checkpatch for catching show-stoppers for application and then something
>> more akin to a CodingStyle validator for the folks interested in
>> arbitrarily defining convention, which they can use freely while the rest
>> of us try to get something useful done.
> 
> /me thinks of ... checkpath --check-me-harder

Yep I think the consensus is we need a
"--i-don't-agree-just-check-things-which-will-get-me-rejected-out-of-hand"
option of some sort which will restrict output to the real errors.

-apw

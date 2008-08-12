Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYHLNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYHLNrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYHLNq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:29 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46529 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYHLNq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:27 -0400
Message-ID: <48A1944C.2010407@keyaccess.nl>
Date: Tue, 12 Aug 2008 15:46:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, fritz@isdn4linux.de, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
References: <489DD669.2090207@keyaccess.nl> <20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org> <48A11952.6090203@keyaccess.nl> <20080811223043.9ad55c51.akpm@linux-foundation.org> <20080812130823.GD13910@cs181140183.pp.htv.fi> <48A18F7B.6040809@keyaccess.nl>
In-Reply-To: <48A18F7B.6040809@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-08 15:26, Rene Herman wrote:

> On 12-08-08 15:08, Adrian Bunk wrote:

>> Write the required settings into a file and use KCONFIG_ALLCONFIG.
> 
> Found those, but seems unable to express the "depends on BROKEN_BOOT if 
> FOO=y" method that's currently used.
> 
> Yes, might admittedly not be considered a huge problem and perhaps we 
> could just ship an allyes.config (and same allrandom.config) but it's 
> not nice to spread information about a single symbol over various files 
> like that.
> 
> Currently, we have a tristate that turns into a y/n bool if !MODULES. 
> What would be real nice here is a tristate that turns into a m/n bool if 
> !RANDOM, where allyesconfig and randconfig would pre-select RANDOM.

(I ofcourse mean "if RANDOM" here)

> If I'm not mistaken, that's currently not possible...

Rene.


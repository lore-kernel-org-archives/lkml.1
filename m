Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYHLNxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYHLNxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYHLNxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:53:08 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49365 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYHLNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:53:07 -0400
Message-ID: <48A195DD.5050602@keyaccess.nl>
Date: Tue, 12 Aug 2008 15:53:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, fritz@isdn4linux.de, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
References: <489DD669.2090207@keyaccess.nl> <20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org> <48A11952.6090203@keyaccess.nl> <20080811223043.9ad55c51.akpm@linux-foundation.org> <20080812130823.GD13910@cs181140183.pp.htv.fi> <48A18F7B.6040809@keyaccess.nl> <20080812134337.GG13910@cs181140183.pp.htv.fi>
In-Reply-To: <20080812134337.GG13910@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-08 15:43, Adrian Bunk wrote:

>> Currently, we have a tristate that turns into a y/n bool if !MODULES.  
>> What would be real nice here is a tristate that turns into a m/n bool if  
>> !RANDOM, where allyesconfig and randconfig would pre-select RANDOM.
> 
> allyesconfig is not random.

Oh, how very, very important. s/RANDOM/!SPECIFIC/ then (and I meant "if 
RANDOM" ofcourse).

The point is just that such a tristate would be a one-stop mark for 
drivers/options that you want to be  specifically selected for builtin 
use since they're not necessarily expected to boot on general PCs.

Rene.

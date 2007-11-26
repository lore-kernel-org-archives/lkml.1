Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXKZQzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXKZQzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbXKZQyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:54:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:18393 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489AbXKZQyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:54:49 -0500
Message-ID: <474AFA2C.5080800@oracle.com>
Date: Mon, 26 Nov 2007 08:54:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: rae l <crquan@gmail.com>, Joe Perches <joe@perches.com>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
References: <1196061373-6394-1-git-send-email-crquan@gmail.com> <1196062867.8948.25.camel@localhost> <91b13c310711260037o7af4b11dt389bb209a075c25a@mail.gmail.com> <20071126132513.GA3230@parisc-linux.org>
In-Reply-To: <20071126132513.GA3230@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Nov 26, 2007 at 04:37:50PM +0800, rae l wrote:
>> I know this is different from the original hexdump in ide-scsi.c, I
>> just want to tell someone that there's a good implementation of
>> hexdump in kernel.h, and I think the default KERN_DEBUG and
>> print_hex_dump is more informative and has better output. However,
>> anyone want more precise control on debug message could make her/his
>> improvements with print_hex_dump.
> 
> using KERN_DEBUG is wrong -- this is part of a line, so you need to use
> KERN_NONE or simply "".

s/KERN_NONE/KERN_CONT/ for continuation lines.

-- 
~Randy

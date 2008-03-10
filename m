Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYCJRcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYCJRcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYCJRcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:32:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYCJRcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:32:04 -0400
Message-ID: <47D56DD3.8060108@zytor.com>
Date: Mon, 10 Mar 2008 18:20:19 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
CC: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <182234194@web.de> <200803101224.07628.dl9pf@gmx.de> <20080310115237.GA29197@elf.ucw.cz> <200803101523.03620.dl9pf@gmx.de>
In-Reply-To: <200803101523.03620.dl9pf@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Simon Möller wrote:
> 
> badram=0x18690000,0xffff0000
> (which means a whole from 0x18690000 to 0x1869ffff )
> 

memmap=0x18690000$64K

	or

memmap=0x18690000$0x10000

	-hpa


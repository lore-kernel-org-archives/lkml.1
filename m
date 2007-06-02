Return-Path: <linux-kernel-owner+w=401wt.eu-S1763737AbXFBXuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763737AbXFBXuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 19:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762470AbXFBXt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 19:49:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbXFBXt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 19:49:57 -0400
Message-ID: <46620218.2090000@zytor.com>
Date: Sat, 02 Jun 2007 16:49:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jonathan Schleifer <js@h3c.de>
CC: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
References: <20070602205513.0312ebe0@localhost>	<4661D32B.2040706@zytor.com>	<20070602233435.4c432bc5@localhost>	<4661ED70.5000208@zytor.com> <20070603004353.3330f35d@localhost>
In-Reply-To: <20070603004353.3330f35d@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Schleifer wrote:
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Partition tables aren't just read at bootup.  We also adjust partition
>> tables at runtime.  Since this is dynamic, ignoring partition tables
>> should be, too.
> 
> So this is something that should be done with a sysctl? Anyway, it
> should also be possible to disable it already at bootup.

Well you have:

- Bootup
- Module insertion
- Removable device insertion
- Partition table change

... to be concerned with.

	-hpa



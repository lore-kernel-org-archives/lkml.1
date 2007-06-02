Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFBWVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFBWVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbXFBWVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:21:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbXFBWVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:21:43 -0400
Message-ID: <4661ED70.5000208@zytor.com>
Date: Sat, 02 Jun 2007 15:21:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jonathan Schleifer <js@h3c.de>
CC: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore partition table on device
References: <20070602205513.0312ebe0@localhost>	<4661D32B.2040706@zytor.com> <20070602233435.4c432bc5@localhost>
In-Reply-To: <20070602233435.4c432bc5@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Schleifer wrote:
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> This seems broken.  If nothing else, there should be ways to enable or
>> disable this at runtime.
> 
> What exactly do you consider broken?
> I don't really see a way to change that at runtime since hard disk
> partition tables are read at bootup. Or did you mean to change the
> device where the partition table should be ignored at runtime, so one
> could enable/disable it and reattach the device under the condition
> that it's a removable device?

Partition tables aren't just read at bootup.  We also adjust partition
tables at runtime.  Since this is dynamic, ignoring partition tables
should be, too.

	-hpa

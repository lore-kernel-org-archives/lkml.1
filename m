Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZHRPnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZHRPnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbZHRPnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:43:20 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:36584 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZHRPnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:43:20 -0400
Message-ID: <fc5d35d666d96f146ac06cd775368580.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <Pine.LNX.4.44L0.0908181114020.3484-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908181114020.3484-100000@iolanthe.rowland.org>
Date: Tue, 18 Aug 2009 09:43:14 -0600
Subject: Re: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 18 Aug 2009, Rick L. Vinyard, Jr. wrote:
>
> Neither one.  If the kernel wanted to add an offset to buf, it would
> have done so before calling the function.  The code should be more like
> this:
>
> 	memcpy(buf, bindata + offset, min(size, bsize - offset));
>

Ahhh, offset into the binary data.

Thanks.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZBNUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZBNUur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBNUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:50:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:42279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZBNUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:50:38 -0500
Subject: Re: RFC: install firmware in a kernel-dependent directory
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <499722DF.3020208@googlemail.com>
References: <4996B838.2070205@googlemail.com>
	 <3f9a31f40902141115w27f20ecfk81213a21dbe1adbd@mail.gmail.com>
	 <499722DF.3020208@googlemail.com>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 21:50:16 +0100
Message-Id: <1234644617.11641.4.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 21:00 +0100, Michael Riepe wrote:
>  
> That means that it shouldn't be delivered with the kernel in the first
> place, right? Neither built in nor as a separate file. Maybe that's an
> even better solution: distribute it separately.

We do. See the linux-firmware.git repository, which contains a bunch of
extra firmware too; not just the bits we've stripped out of legacy
drivers.

You can completely ignore the firmware that's shipped with the kernel,
and you're right -- it should go away. In time I hope it will.

-- 
dwmw2


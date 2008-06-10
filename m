Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYFJOMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYFJOMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYFJOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:12:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:24843 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYFJOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Vy5veWkRBqd/ol+/fDs/ZvKK0LaUlnb/6kBt32IRLPLUxHgA5TONOvUK2Eg3BLWFPd
         BblOAyh/rPa9AvKLyB8SzeyDCekaR35GrcfYBF6kw4zlig9eJs+4/Rcp7X4IhspQHXxP
         fzBdzU5DR97YPo3kod92IeZmQmN8dGLlQbb/U=
Message-ID: <fb6f288a0806100712o63b35c25i3e20a33016d3b760@mail.gmail.com>
Date: Tue, 10 Jun 2008 17:12:37 +0300
From: "Eric Silverstein" <silverstein.eric@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: memory mapping of memory allocated by alloc_bootmem_pages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just want to make sure that I didn't miss any limitation about
memory mapping: I would like to allocate a huge amount of contiguous
physical memory for a userspace application. I was thinking about
using something like alloc_bootmem_pages and mmap it, so I can use it
from userland. Should this work?

Thanks,
Eric

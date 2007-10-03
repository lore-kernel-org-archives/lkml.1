Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbXJCRjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbXJCRjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXJCRjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:39:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:8165 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbXJCRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BAyQ5RbBhAhGslM2nTtOVz1BX7w1uuF4LA0M7FjtqLs1gJLjfZKs+oMoxKhigluyQsK2DXJIURhZTv7F9VWrSA/efo8ZQJyXcKiat4aXWDkO8ySIxy88vyhNF4tNd+QjUvWQIK1i+snPgslyRV9wrwht5PBIHAu6IQfXtXtD4D0=
Message-ID: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
Date: Wed, 3 Oct 2007 10:39:34 -0700
From: "Mike Robak" <mrobak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: libATA error message doc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does a doc exist that provides a detailed description of the different
errors that could be produced by libata and its associated drivers?
The libATA developer's guide provides a very good general description
of the types of messages, but I'm looking for more detail.

For example I got this error message last week:

Sep 27 17:29:26 server kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x1
Sep 27 17:29:26 server kernel: ata2.00: (irq_stat 0x40000001)
Sep 27 17:29:26 server kernel: ata2.00: tag 0 cmd 0xb0 Emask 0x1 stat
0x51 err 0x4 (device error)

I'd like to know what the following items means?

(irq_stat 0x40000001)
tag 0
cmd 0xb0
emask 0x1
stat 0x51
err 0x4


Can anybody help?

Thanks,
-Mike

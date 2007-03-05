Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXCERtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXCERtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXCERtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:49:35 -0500
Received: from thccv19.oz.nthu.edu.tw ([140.114.63.219]:45230 "EHLO
	thccv19.oz.nthu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXCERte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:49:34 -0500
From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
To: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: How to copy a page to another page completely?
Date: Tue, 6 Mar 2007 01:49:29 +0800
Message-ID: <000001c75f4e$a0674a00$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcdfTp86sZmFcwrfQ3yL6EQQ7KYrKQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I tried "memcpy","__copy_to_user",and "__copy_to_user_inatomic",etc.
The destination is BIO's bio_vec->page (the page should be in userspace),
the source is a page of my modules; 
I get the addresses of the both pages from kmap() or kmap_atomic() then pass
to "memcpy" or "__copy_to_user" or "__copy_to_user_inatomic".
If the method can work, the buffer of userspace process will have the
context of the page of my module.
There is a problem that the context of buffer is incomplete when first run,
and the problem will disappear when run more time.
How to copy a page to another page completely?

THX


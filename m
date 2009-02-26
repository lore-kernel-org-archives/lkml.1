Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZBZThP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZBZThP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBZThA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:37:00 -0500
Received: from web39808.mail.mud.yahoo.com ([209.191.106.69]:22740 "HELO
	web39808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751747AbZBZTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:36:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=cNZCX9ilQW48DNEir2+imtPLdHF0Quo2BAioizrHGH/33gSaIoHGkzLD5B/cZN+scqzDPgPnByhQpzCdH7GxX9VQR2WyPzuJpEvjqZaTUi3nu7K1CjrXfuE8zw+KYp8QLHzLFJ1xPg7RqpekZkIDzBnPUt1E8v70gCS2mTIzbAY=;
X-YMail-OSG: X0JVAKwVM1krYf7bZvINzB1yCXwfxgbcgSYtCvBzUY_mDuANQy5DjqwL0cbRAUtqx5TNQVHnPjSHi1G6SJdhmSt80Joe7BIhMyajPmITl.u7uUPjaH66yfUykO4XZIqrikjO9IWSteEGKL7r6j2mPLV5yw--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Thu, 26 Feb 2009 11:36:57 -0800 (PST)
From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: Page protection flags in linux on an x86 platform
To: linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <356809.23263.qm@web39808.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Folks,

I am trying to port some PPC code to x86 based linux. My question is that I am need to create some page mappings using remap_pfn_range. In the code for the PPC,
the protection flags being specified are:

__pgprot(_PAGE_NO_CACHE | _PAGE_GUARDED);

But it looks like these do not exist when linux is compiled for the x86 architecture. 

What are the relevant protection flags to achieve the same for the x86 architecture. 

Thanks for your help.

- Vinay


      

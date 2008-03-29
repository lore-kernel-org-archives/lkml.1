Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYC2RTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYC2RTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYC2RTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:19:45 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59660 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYC2RTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:19:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18414.31274.514325.238985@harpo.it.uu.se>
Date: Sat, 29 Mar 2008 18:19:38 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
In-Reply-To: <47EE75A0.8070705@gmail.com>
References: <47EE75A0.8070705@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak writes:
 > Hi All,
 > 
 > I've found that in many enum lists, there's a comma at the end, e.g. 
 > (arch/x86/kernel/early_printk.c):
 > 
 > enum {
 >          MAGIC1 = 0xBACCD00A,
 >          MAGIC2 = 0xCA110000,
 >          XOPEN = 5,
 >          XWRITE = 4,
 > };
 > 
 > Just out of curiosity, is there any particular reason here (no word in 
 > CodingStyle about that).

Yes. This idiom allows you to add or remove items without
changing adjacent lines.

In a language with strict a comma-as-separator rule you can
get this benefit by placing the comma before new items rather
than after existing items:

enum {	FOO
	,FIE
	,FUM
};

but luckily C doesn't need this perversion.

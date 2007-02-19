Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXBSOTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXBSOTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXBSOTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:19:39 -0500
Received: from smtp.nokia.com ([131.228.20.172]:60248 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbXBSOTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:19:38 -0500
Subject: Re: [PATCH 09/44 take 2] [UBI] debug unit header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1171893769.24204.15.camel@zod.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165509.5845.12977.sendpatchset@localhost.localdomain>
	 <200702172218.22709.arnd@arndb.de>  <1171888399.13817.21.camel@sauron>
	 <1171893769.24204.15.camel@zod.rchland.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 16:04:29 +0200
Message-Id: <1171893869.14817.2.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 14:04:29.0225 (UTC) FILETIME=[DF23E990:01C7542E]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219160145-2FA1CBB0-5F4275B9/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 08:02 -0600, Josh Boyer wrote:
> It is not the comment that annoys people.  Arnd was saying that the
> entire debug unit should not exist.

There is many per-subsystem debugging stuff in kernel. I do not see
_objective_ any reason to prohibit use have our own debugging stuff in
UBI. It is compiled out when disabled. It helps to quickly fix bugs. It
helps to check if new patches introduce bugs (assertions, paranoid
checks). These are _objective_ reasons to keep it.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)


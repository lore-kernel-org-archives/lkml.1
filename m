Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbZGQH3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbZGQH3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 03:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934154AbZGQH3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 03:29:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27381 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136AbZGQH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:29:50 -0400
Subject: Re: [PATCH] Clean up some extra unused arguments in fs/ubifs/
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>
References: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jul 2009 10:28:38 +0300
Message-Id: <1247815718.11353.177.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2009 07:28:46.0864 (UTC) FILETIME=[38B16100:01CA06B0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 11:51 +0530, Subrata Modak wrote:
> Hi,
> 
> "const struct ubifs_info *c" exists as an extra argument for major
> function definitions under the "fs/ubifs/*" code. The reason why
> this extra argument exists is based on assumtion that there
> will be several key schemes. It is possible to add more than one,
> but we use only one. When there is practically no usage of them
> presently, they can be removed, and if needed can be added later.
> 
> The following patch does that by removing:
> 1) "const struct ubifs_info *c" where it is not used/necessary,
> 2) remove xent_key_init_hash() function, as it is also not used,
> 3) remove data_key_init_flash() function, as it is also not used anywhere,

Fine with 2 and 3. Not fine with 1, unless it makes the code smaller
or more optimal.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764060AbXHABpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764060AbXHABpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXHABpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:45:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59740 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbXHABp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:45:29 -0400
Subject: Re: "Add support for vector domain" breaks boot on x355
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: isimatu.yasuaki@jp.fujitsu.com, tony.luck@intel.com,
       torvalds@linux-foundation.org, ryhodges@us.ibm.com,
       linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731221356.GA31324@us.ibm.com>
References: <20070731221356.GA31324@us.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Date: Wed, 01 Aug 2007 10:43:43 +0900
Message-Id: <1185932623.3920.5.camel@kane-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007-07-31 (火) の 15:13 -0700 に Nishanth Aravamudan さんは書きました:
> The following commit (4994be1b3fe9120c88022ff5c0c33f6312b17adb) broke
> Linus' Tree between 2.6.22-git15 and 2.6.22-git16 on a 2-node 8-way x455
> (Madison procs). Thanks to Ryan Hodges for bisecting down to this
> commit.

Thank you for reporting.

I think this problem might be fixed by the commit
6ffbc82351c62eeeeaeb9e817ddf93049353493d. Could you try that?

Thanks,
Kenji Kaneshige



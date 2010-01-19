Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905Ab0ASLAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0ASLAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394Ab0ASLAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:00:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab0ASLAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:00:10 -0500
Date: Tue, 19 Jan 2010 02:57:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Miller <davem@davemloft.net>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed
 MAC addresses
Message-Id: <20100119025734.ce74ae5b.akpm@linux-foundation.org>
In-Reply-To: <1262888625.10429.23.camel@Joe-Laptop.home>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com>
	<1262888625.10429.23.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 10:23:45 -0800 Joe Perches <joe@perches.com> wrote:

> Adds 56 bytes to object size

You might want to consider making some of the net-specific code in
vsprintf.c go away if CONFIG_NET=n.


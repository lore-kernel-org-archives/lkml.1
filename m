Return-Path: <linux-kernel-owner+w=401wt.eu-S1031138AbXECKRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031138AbXECKRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031150AbXECKRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:17:21 -0400
Received: from eth8932.sa.adsl.internode.on.net ([150.101.246.227]:37166 "EHLO
	aix.gdt.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031138AbXECKRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:17:19 -0400
Subject: Re: Detecting process death for anycast named process monitoring
From: Glen Turner <gdt@gdt.id.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070503024048.e7192b3b.akpm@linux-foundation.org>
References: <4638FCEA.4010806@gdt.id.au>
	 <20070503024048.e7192b3b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Glen Turner <http://www.aarnet.edu.au/~gdt/>
Date: Thu, 03 May 2007 19:47:22 +0930
Message-Id: <1178187442.3887.0.camel@thrace>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 02:40 -0700, Andrew Morton wrote:
> Monitor the system using the taskstats interface.  There is a sample
> application and documentation in Documentation/accounting/.
> 
> Your monitoring application will receive a netlink packet each time a process
> exits.  It includes the exit code and the process's name.

Marvellous, just what is needed.  Thank you Andrew.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYFKS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYFKS2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYFKS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:28:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52806 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYFKS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:28:32 -0400
Subject: Re: [BUG] 2.6.26-rc5-mm2 - kernel BUG at
	arch/x86/kernel/setup.c:388!
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <485011DF.9050606@linux.vnet.ibm.com>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	 <485011DF.9050606@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Jun 2008 11:28:17 -0700
Message-Id: <1213208897.20475.19.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 23:26 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64
> box with the attached .config file.

Just to save everyone the trouble, it looks like this is a new BUG_ON().
﻿
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/broken-out/fix-x86_64-splat.patch

The machine in question is a single-node machine, but with
CONFIG_NUMA=y.







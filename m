Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYHLSaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYHLSaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYHLSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:30:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbYHLSaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:30:04 -0400
Message-ID: <48A1D65A.8000600@linux-foundation.org>
Date: Tue, 12 Aug 2008 13:28:42 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-mm@kvack.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for August 11/12 - powerpc - oops at __kmalloc_node_track_caller
 ()
References: <20080812185345.d7496513.sfr@canb.auug.org.au> <48A1C924.6020000@linux.vnet.ibm.com>
In-Reply-To: <48A1C924.6020000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reboot and switch on debugging by either specifying slub_debug as a kernel
command line parameter or setting CONFIG_SLUB_DEBUG_ON. This looks like the
freelists are corrupted. Could be a use after free or something.



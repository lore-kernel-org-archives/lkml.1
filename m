Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXBUPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXBUPRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161067AbXBUPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:17:40 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40686 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269AbXBUPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:17:40 -0500
Subject: Re: [PATCH] [MTD] CHIPS: oops in cfi_amdstd_sync
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Vijay Sampath <vsampath@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070221145420.GD464@lazybastard.org>
References: <758a2bbf0702201746p3959235ele3db9b600a9f8104@mail.gmail.com>
	 <20070221145420.GD464@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Feb 2007 09:18:40 -0600
Message-Id: <1172071120.24204.167.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 14:54 +0000, Jörn Engel wrote:
> On Tue, 20 February 2007 17:46:13 -0800, Vijay Sampath wrote:
> > 
> > The files cfi_cmdset_0002.c and cfi_cmdset_0020.c do not initialize
> > their wait queues like is done in cfi_cmdset_0001.c. This causes an
> > oops when the wait queue is accessed. I have copied the code from
> > cfi_cmdset_0001.c that is pertinent to initialization of the wait
> > queue.
> 
> Patch looks good, but I can no longer test it.  Josh may still have
> access to some commandset 20 chips.  Josh, any objections?

The patch looks good to me as well.  No access to those chips anymore,
but I have no objections.

josh


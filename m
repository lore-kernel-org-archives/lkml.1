Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYAKFnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYAKFnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 00:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYAKFnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 00:43:09 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:62070 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYAKFnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 00:43:07 -0500
To: pw@osc.edu
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp,
       tomof@acm.org, deepakrc@gmail.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg : Add support for io vectors in bsg
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080110214605.GD1928@osc.edu>
References: <20080110204325.GC1928@osc.edu>
	<1199998531.3141.96.camel@localhost.localdomain>
	<20080110214605.GD1928@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080111144249H.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 11 Jan 2008 14:42:49 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 16:46:05 -0500
Pete Wyckoff <pw@osc.edu> wrote:

> Is there another async I/O mechanism?  Userspace builds the CDBs,
> just needs some way to drop them in SCSI ML.  BSG is almost perfect
> for this, but doesn't do iovec, leading to lots of memcpy.

syslets?

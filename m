Return-Path: <linux-kernel-owner+w=401wt.eu-S1767601AbXEDGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767601AbXEDGN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXEDGNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:13:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37519 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXEDGNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:13:24 -0400
Date: Fri, 4 May 2007 09:13:22 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] revoke: change revoke_table to fileset and revoke_details
In-Reply-To: <20070503170447.8520da9c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705040912520.25501@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705031752440.6505@sbz-30.cs.Helsinki.FI>
 <20070503132253.7b6fe5fe.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705032329220.14781@sbz-30.cs.Helsinki.FI>
 <20070503170447.8520da9c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:
> Well that's the "locking" protocol then: each instance of this structure is
> only ever touched by a single thread, yes?

Yes. Each do_revoke() call creates a new instance.

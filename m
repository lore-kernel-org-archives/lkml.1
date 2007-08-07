Return-Path: <linux-kernel-owner+w=401wt.eu-S934681AbXHGRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbXHGRsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbXHGRsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:48:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33409 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbXHGRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:48:08 -0400
Subject: Re: [PATCH] Workaround for rq->lock deadlock
From: Gregory Haskins <ghaskins@novell.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dwalker@mvista.com, mingo@elte.hu
In-Reply-To: 20070807173827.3210.85330.stgit@lsg
References: 20070807173827.3210.85330.stgit@lsg
Content-Type: text/plain
Date: Tue, 07 Aug 2007 13:46:16 -0400
Message-Id: <1186508776.21381.192.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 11:43 -0600, Gregory Haskins wrote:
> The following patch converts double_lock_balance to a full DP alogorithm to
> work around a deadlock in the scheduler when running on an 8-way SMP system.

To LKML:  This is an RT specific patch.  I forgot to change the subject
line.  Sorry for the confusion.

-Greg



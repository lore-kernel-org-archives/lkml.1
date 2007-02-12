Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXBLJCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXBLJCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXBLJCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:02:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbXBLJCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:02:35 -0500
Date: Mon, 12 Feb 2007 00:45:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system---Take-2
Message-Id: <20070212004515.b66ec836.akpm@linux-foundation.org>
In-Reply-To: <45CB0D87.8070808@in.ibm.com>
References: <45C85097.1000106@in.ibm.com>
	<20070206100607.GA10296@infradead.org>
	<45C856F1.7060403@in.ibm.com>
	<45C894EA.4060305@in.ibm.com>
	<20070206145609.GA11249@slug>
	<45C962C3.2020904@in.ibm.com>
	<20070207142717.5da4d8d4.akpm@linux-foundation.org>
	<45CB0D87.8070808@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 17:16:15 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> +	if (p->pre_handler == pre_handler_kretprobe)

This breaks on sparc64:

kernel/kprobes.c: In function `report_probe':
kernel/kprobes.c:826: error: `pre_handler_kretprobe' undeclared (first use in this function)

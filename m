Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYCJR6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYCJR6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYCJR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:57:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYCJR5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:57:53 -0400
Date: Mon, 10 Mar 2008 13:57:16 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH] sysrq show-all-cpus
Message-ID: <20080310135716.0c99a202@bree.surriel.com>
In-Reply-To: <20080310104154.56fd4825.akpm@linux-foundation.org>
References: <20080310133242.0ab69084@bree.surriel.com>
	<20080310104154.56fd4825.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 10:41:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> How come the sysrq-handling CPU uses show_regs() and the others use
> show_stack()?  Do we not set up the get_irq_regs() data for IPIs?

I tried it that way, and the other CPUs never printed anything.

I guess get_irq_regs() data is not present when in an IPI.

-- 
All rights reversed.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYAKPjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYAKPjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbYAKPi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:38:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbYAKPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:38:58 -0500
Date: Fri, 11 Jan 2008 10:38:42 -0500
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080111103842.60133336@bree.surriel.com>
In-Reply-To: <20080111104115.GA19814@balbir.in.ibm.com>
References: <20080108205939.323955454@redhat.com>
	<20080111104115.GA19814@balbir.in.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 16:11:15 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I've just started the patch series, the compile fails for me on a
> powerpc box. global_lru_pages() is defined under CONFIG_PM, but used
> else where in mm/page-writeback.c. None of the global_lru_pages()
> parameters depend on CONFIG_PM. Here's a simple patch to fix it.

Thank you for the fix.  I have applied it to my tree.

-- 
All rights reversed.

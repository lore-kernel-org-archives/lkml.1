Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXKGD0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXKGD0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXKGD0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:26:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38076 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754232AbXKGD0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:26:34 -0500
Date: Tue, 6 Nov 2007 19:26:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/10] define page_file_cache
In-Reply-To: <20071106221710.3f9b8dd6@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061920510.5746@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103185516.24832ab0@bree.surriel.com> <Pine.LNX.4.64.0711061821010.5249@schroedinger.engr.sgi.com>
 <20071106215552.4ab7df81@bree.surriel.com> <Pine.LNX.4.64.0711061856400.5565@schroedinger.engr.sgi.com>
 <20071106221710.3f9b8dd6@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n Tue, 6 Nov 2007, Rik van Riel wrote:

> Every anonymous, tmpfs or shared memory segment page is potentially
> swap backed. That is the whole point of the PG_swapbacked flag.

One of the current issues with anonymous pages is the accounting when 
they become file backed and get dirty. There are performance issue with 
swap writeout because we are not doing it in file order and on a page by 
page basis.

Do ramfs pages count as memory backed?
 
> A page from a filesystem like ext3 or NFS cannot suddenly turn into
> a swap backed page.  This page "nature" is not changed during the
> lifetime of a page.

Well COW sortof does that but then its a new page.


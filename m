Return-Path: <linux-kernel-owner+w=401wt.eu-S1764749AbYBHReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764749AbYBHReg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbYBHReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:34:23 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35559 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbYBHReU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:34:20 -0500
Date: Fri, 8 Feb 2008 09:33:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-Id: <20080208093341.b4d02e22.randy.dunlap@oracle.com>
In-Reply-To: <47AC87AE.9040408@steeleye.com>
References: <47AC87AE.9040408@steeleye.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 11:47:42 -0500 Paul Clements wrote:

> There have been numerous reports of problems with nbd and cfq. Deadline 
> gives better performance for nbd, anyway, so let's use it by default.

so what happens with this patch on cfq-only or as-only kernels?

---
~Randy

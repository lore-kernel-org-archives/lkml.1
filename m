Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbYAMFXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbYAMFXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 00:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYAMFXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 00:23:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYAMFXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 00:23:43 -0500
Date: Sun, 13 Jan 2008 00:18:27 -0500
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 18/19] account mlocked pages
Message-ID: <20080113001827.76e5a64c@bree.surriel.com>
In-Reply-To: <20080111125109.GC19814@balbir.in.ibm.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210019.684039300@redhat.com>
	<20080111125109.GC19814@balbir.in.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 18:21:09 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Rik van Riel <riel@redhat.com> [2008-01-08 15:59:57]:
> 
> The following patch is required to compile the code with
> CONFIG_NORECLAIM enabled and CONFIG_NORECLAIM_MLOCK disabled.

I have untangled the #ifdefs to make things compile with
all combinations of config settings.  Thanks for pointing
out this problem.

-- 
All rights reversed.

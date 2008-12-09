Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbYLICdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbYLICdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYLICdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:33:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbYLICdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:33:01 -0500
Date: Mon, 8 Dec 2008 18:32:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Brent Casavant <bcasavan@sgi.com>
Cc: linux-kernel@vger.kernel.org, mdr@sgi.com, rw@novell.com,
       kasievers@novell.com
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
Message-Id: <20081208183226.ef5eabdb.akpm@linux-foundation.org>
In-Reply-To: <alpine.BSF.1.10.0812081932180.1046@pkunk.americas.sgi.com>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com>
	<20081208145507.8d03834e.akpm@linux-foundation.org>
	<alpine.BSF.1.10.0812081932180.1046@pkunk.americas.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 20:01:31 -0600 (CST) Brent Casavant <bcasavan@sgi.com> wrote:

> > This race is fixable by adding a flush_scheduled_work() into
> > ioc4_exit(), I expect.
> 
> In this case I believe a better spot for the flush_schedule_work() is
> immediately after calling schedule_work()

That is equivalent to calling the work function directly.

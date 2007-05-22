Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXEVEJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXEVEJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXEVEJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:09:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbXEVEJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:09:05 -0400
Date: Mon, 21 May 2007 21:07:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Delay writing 0's after llseek until write
Message-Id: <20070521210708.67d365dc.akpm@linux-foundation.org>
In-Reply-To: <20070521230021.GD3621@us.ibm.com>
References: <20070521230021.GD3621@us.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 18:00:21 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Delay writing 0's out in eCryptfs after a seek past the end of the
> file until data is actually written.

a) why?

b) what is the impact upon a user of them not having this patch?

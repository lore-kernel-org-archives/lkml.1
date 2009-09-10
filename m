Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZIJUoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZIJUoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZIJUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:44:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbZIJUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:44:12 -0400
Date: Thu, 10 Sep 2009 13:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       zhenyuw@linux.intel.com, stable@kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/3] agp/intel: remove restore in resume
Message-Id: <20090910134252.5fc54ce2.akpm@linux-foundation.org>
In-Reply-To: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
References: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Sep 2009 09:43:34 +0800
Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> As early pci resume has already restored config for host
> bridge and graphics device, don't need to restore it again,
> which might cause problem on some chips, like 845G tested by
> Alan Stern.
> 
> Cc: Stable Team <stable@kernel.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Why were these patches cc'ed to stable@kernel.org?  There's nothing in
the changelog which explains why the problem which is being fixed is
sufficiently serious to warrant backporting the patch.

Was there a [patch 3/3]?  I didn't receive it.

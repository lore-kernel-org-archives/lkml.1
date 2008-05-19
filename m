Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYESHaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYESHaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYESH3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:29:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbYESH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:29:51 -0400
Date: Mon, 19 May 2008 00:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.26-rc2-mm1] sync to speed up?
Message-Id: <20080519002919.1f8f21f6.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
References: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 15:15:09 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Hi,
> 
> With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
> understanding.
> 
> 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
> but the speed will slow down to 100K/s at last. After I exec "sync",
> the speed will restore.
> 
> Is this a known issue?
> 

Yes, probably related to the "mkfs takes forever" problem.  I haven't
looked into it yet.  Nor has anyone else afaik.


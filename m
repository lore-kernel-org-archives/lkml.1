Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYFXA2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYFXA2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYFXA2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:28:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYFXA2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:28:39 -0400
Date: Mon, 23 Jun 2008 17:27:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Full conversion to early_initcall() interface,
 remove old interface.
Message-Id: <20080623172742.be332a53.akpm@linux-foundation.org>
In-Reply-To: <20080623153056.1862c14e@linux360.ro>
References: <20080623153056.1862c14e@linux360.ro>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 15:30:56 +0300
Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> A previous patch added the early_initcall(), to allow a cleaner hooking of
> pre-SMP initcalls. Now we remove the older interface, converting all
> existing users to the new one.

The patch failed to convert init_call_single_data() because you're
working against a two-month-old codebase.  Patches against linux-next
are more appropriate, particularly late in -rc.

Please check that what I committed actually worked, thanks.

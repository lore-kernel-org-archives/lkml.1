Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYLBGsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYLBGsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYLBGs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:48:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbYLBGs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:48:26 -0500
Date: Mon, 1 Dec 2008 22:47:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/6] cpumask: switch over to
 cpu_online/possible/active/present_mask: core
Message-Id: <20081201224739.958b3942.akpm@linux-foundation.org>
In-Reply-To: <200812011847.38877.rusty@rustcorp.com.au>
References: <200812011847.38877.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 18:47:38 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> + *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration

I completely missed the addition of cpu_active :(

It isn't completely clear to me why this exists.  Are the various state
transitions documeted anywhere?

<looks at the changelog>

It says "This is based on Linus' idea of ...", but it doesn't actually
describe that idea.  bah.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZGWWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZGWWFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZGWWFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:05:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664AbZGWWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:05:48 -0400
Date: Thu, 23 Jul 2009 15:05:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: venkatesh.pallipadi@intel.com, abelay@novell.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu governor: reduce latency on exit
Message-Id: <20090723150517.fbbd03dc.akpm@linux-foundation.org>
In-Reply-To: <200907191659.47179.czoccolo@gmail.com>
References: <200907191659.47179.czoccolo@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009 16:59:46 +0200
Corrado Zoccolo <czoccolo@gmail.com> wrote:

> This patch moves the state residency accounting and statistics
> computation off the hot exit path.
> On exit, the need to recompute statistics is recorded, and new
> statistics will be computed when menu_select is called again.
> 

Was there any observed and/or measured effect as a result of this patch?

If so, please send a description of that effect, thanks.


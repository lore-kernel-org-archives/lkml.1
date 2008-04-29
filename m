Return-Path: <linux-kernel-owner+w=401wt.eu-S936161AbYD2A4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936161AbYD2A4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762989AbYD2A4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:56:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35588 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYD2A4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:56:23 -0400
Date: Tue, 29 Apr 2008 10:00:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.24 regression: deadlock on coredump of big process
Message-Id: <20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4815E932.1040903@cybernetics.com>
References: <4815E932.1040903@cybernetics.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 11:11:46 -0400
Tony Battersby <tonyb@cybernetics.com> wrote:

> Below is the program that triggers the deadlock; compile with
> -D_REENTRANT -lpthread.
> 
What happens if you changes size of stack (of pthreads) smaller ?
(maybe ulimit -s will work also for threads.)

Thanks,
-Kame


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZCYBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZCYBIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZCYBIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:08:31 -0400
Received: from ozlabs.org ([203.10.76.45]:40222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZCYBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:08:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: ftrace not working?
Date: Wed, 25 Mar 2009 11:38:24 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?utf-8?q?Fr=E9=A6=98=E9=A7=BBic_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20090323083533.GE18837@elte.hu> <20090323143226.GA18439@elte.hu> <200903242253.36794.knikanth@suse.de>
In-Reply-To: <200903242253.36794.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251138.24660.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 03:53:35 Nikanth Karthikesan wrote:
> On Monday 23 March 2009 20:02:26 Ingo Molnar wrote:
> The tracing_buffer_mask was getting freed and the bitmask was all zeros. And
> for_each_tracing_cpu() never looped. Here is the patch that fixes the issue
> for me. Tested only on qemu-kvm. ;)
> 
> Steve, Can you merge this.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.

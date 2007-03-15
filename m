Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXCOTIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXCOTIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXCOTIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:08:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbXCOTIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:08:24 -0400
Date: Thu, 15 Mar 2007 11:07:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre.Peiffer@bull.net
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net, pierre.peiffer@bull.net
Subject: Re: [PATCH 2.6.21-rc3-mm2 4/4] sys_futex64 : allows 64bit futexes
Message-Id: <20070315110752.f1df4509.akpm@linux-foundation.org>
In-Reply-To: <20070313095549.813330645@bull.net>
References: <20070313095203.154246923@bull.net>
	<20070313095549.813330645@bull.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 10:52:07 +0100 Pierre.Peiffer@bull.net wrote:
> This last patch is an adaptation of the sys_futex64 syscall provided in -rt
> patch (originally written by Ingo). It allows the use of 64bit futex.
> 
> I have re-worked most of the code to avoid the duplication of the code.
> 
> It does not provide the functionality for all architectures (only for x64 for now).

What a lot of code.

Why do we want 64-bit futexes?

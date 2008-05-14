Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbYENNM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbYENNM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762499AbYENNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:11:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762470AbYENNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:11:03 -0400
Message-ID: <482AE4DE.2050709@redhat.com>
Date: Wed, 14 May 2008 09:10:54 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]: ftrace: Remove packed attribute on ftrace_page.
References: <20080513.220656.213078618.davem@davemloft.net>
In-Reply-To: <20080513.220656.213078618.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> It causes unaligned access traps on platforms like sparc
> (ftrace_page may be marked packed, but once we return
> a dyn_ftrace sub-object from this array to another piece
> of code, the "packed" part of the typing information doesn't
> propagate).
> 
> But also, it didn't serve any purpose either.  Even if packed,
> on 64-bit or 32-bit, it didn't give us any more dyn_ftrace
> entries per-page.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

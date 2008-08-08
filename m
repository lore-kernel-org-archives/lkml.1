Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYHHXHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYHHXHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763928AbYHHXHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:07:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760948AbYHHXHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:07:32 -0400
Message-ID: <489CD18A.9000800@zytor.com>
Date: Fri, 08 Aug 2008 16:06:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 ioperm user_regset
References: <20080808225840.04ECD154208@magilla.localdomain>
In-Reply-To: <20080808225840.04ECD154208@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> [PATCH] x86 ioperm user_regset
> 
> This adds a user_regset type for the x86 io permissions bitmap.
> This makes it appear in core dumps (when ioperm has been used).
> It will also make it visible to debuggers in the future.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Applied to tip:x86/ptrace; will push after compile test.

Thanks!

	-hpa

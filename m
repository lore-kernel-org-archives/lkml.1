Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYJQQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYJQQf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYJQQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:35:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYJQQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:35:51 -0400
Message-ID: <48F8BEE1.1010000@zytor.com>
Date: Fri, 17 Oct 2008 09:35:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add missed clobber for 32-bit memmove
References: <1224249353-3032-1-git-send-email-albcamus@gmail.com> <1224249353-3032-2-git-send-email-albcamus@gmail.com>
In-Reply-To: <1224249353-3032-2-git-send-email-albcamus@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> memmove() is implemented by inline assembly. It calls std at first
> and cld at last, but EFLAGS still should be clobbered.

gcc always treats EFLAGS as clobbered on x86.  The "cc" clobber is 
needed on some platforms, but is a noop on x86.

	-hpa

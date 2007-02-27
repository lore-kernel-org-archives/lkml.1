Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXB0TRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXB0TRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXB0TRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:17:11 -0500
Received: from terminus.zytor.com ([192.83.249.54]:45168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXB0TRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:17:10 -0500
Message-ID: <45E4838D.2050006@zytor.com>
Date: Tue, 27 Feb 2007 11:16:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Florin Malita <fmalita@gmail.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devpts: add fsnotify create event
References: <45DBD56B.30104@gmail.com>
In-Reply-To: <45DBD56B.30104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Malita wrote:
> Currently, devpts doesn't generate an fsnotify event upon pts creation 
> because the regular vfs paths aren't involved. Deallocation, on the 
> other hand, correctly generates a nameremove event thanks to the 
> d_delete() invocation in devpts_pty_kill().
> 
> This patch adds the missing fsnotify_create() trigger in devpts_pty_new().
> 
> Signed-off-by: Florin Malita <fmalita@gmail.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

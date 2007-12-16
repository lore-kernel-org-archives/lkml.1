Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXLPXgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXLPXgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbXLPXgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:36:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515AbXLPXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:36:34 -0500
Date: Sun, 16 Dec 2007 15:35:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] mmap read-around and readahead
In-Reply-To: <397806667.28507@ustc.edu.cn>
Message-ID: <alpine.LFD.0.9999.0712161535090.21557@woody.linux-foundation.org>
References: <397806667.28507@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Dec 2007, Fengguang Wu wrote:
> 
> Here are the mmap read-around related patches initiated by Linus.
> They are for linux-2.6.24-rc4-mm1.  The one major new feature -
> auto detection and early readahead for mmap sequential reads - runs
> as expected on my desktop :-)

Just out of interest - did you check to see if it makes any difference to 
any IO patterns (or even timings)?

		Linus

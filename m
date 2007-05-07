Return-Path: <linux-kernel-owner+w=401wt.eu-S934418AbXEGQqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbXEGQqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXEGQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:46:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34743 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406AbXEGQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:46:12 -0400
Message-ID: <463F57CB.4090301@zytor.com>
Date: Mon, 07 May 2007 09:46:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com> <46398FCF.80100@gmail.com> <200705031433.09364.a1426z@gawab.com>
In-Reply-To: <200705031433.09364.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
> Isn't everything really just temporary?
> 
> Would something like an mmap'd tmpfs be possible?
> 

No.  tmpfs relies on being able to leave data structures in the running
kernel.  In particular, it has no metadata store at all.

The needs for a persistent filesystem are very different, regardless of
what the underlying medium is.

	-hpa

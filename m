Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYKWLFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYKWLFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYKWLFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:05:05 -0500
Received: from styx.suse.cz ([82.119.242.94]:38955 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756725AbYKWLFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:05:04 -0500
Date: Sun, 23 Nov 2008 12:05:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: stern@rowland.harvard.edu, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: remove setup mutex
In-Reply-To: <1227347799-24137-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0811231204150.19853@jikos.suse.cz>
References: <Pine.LNX.4.44L0.0811121650090.2186-100000@iolanthe.rowland.org> <1227347799-24137-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008, Jiri Slaby wrote:

> It causes recursive locking warning and is unneeded after
> introduction of STARTED flag.
> 
> * Resume vs. stop is effectively solved by DISCONNECT flag.
> * No problem in suspend vs. start -- urb is submitted even after open
>   which is possible after connect which is called after start.
> * Resume vs. start solved by STARTED flag.
> * Suspend vs. stop -- no problem in killing urb and timer twice.

Yes, this was exactly point of my original question, thanks a lot for 
doublechecking. Applied.

Thanks,

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYKKWxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYKKWxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYKKWwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:52:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:42455 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbYKKWww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:52:52 -0500
Date: Tue, 11 Nov 2008 23:52:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
In-Reply-To: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0811112352390.24889@jikos.suse.cz>
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Jiri Slaby wrote:

> `stop' left out usbhid->urb* pointers and so the next `start' thought
> it needs to allocate nothing and used the memory pointers previously
> pointed to. This led to memory corruption and device malfunction.
> 
> Also don't forget to clear disconnect flag on start which was left set
> by the previous `stop'.

Applied, thanks Jiri.

-- 
Jiri Kosina
SUSE Labs

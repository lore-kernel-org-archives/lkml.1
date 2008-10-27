Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYJ0Q36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYJ0Q36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYJ0Q3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:29:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:40980 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753614AbYJ0Q3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:29:40 -0400
Date: Mon, 27 Oct 2008 17:29:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH 1/2] HID: don't oops on suspend of non-bound devices
In-Reply-To: <1225106176-5496-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810271729200.12928@jikos.suse.cz>
References: <1225106176-5496-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Jiri Slaby wrote:

> Usbhid structure is allocated on start invoked only from probe
> of some driver. When there is no driver, the structure is null
> and causes null-dereference oopses.
> 
> Fix it by allocating the structure on probe and disconnect of
> the device itself. Also make sure we won't race between start
> and resume or stop and suspend respectively.
> 
> References: http://bugzilla.kernel.org/show_bug.cgi?id=11827

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

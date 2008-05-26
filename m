Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYEZIwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYEZIwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYEZIwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:52:07 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51343 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYEZIwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:52:06 -0400
Date: Mon, 26 May 2008 10:51:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] hidraw: Push down BKL into ioctl handler
In-Reply-To: <20080522215013.374b5e5d@core>
Message-ID: <Pine.LNX.4.64.0805261050560.18218@twin.jikos.cz>
References: <20080522215013.374b5e5d@core>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Alan Cox wrote:

> In this case I simply wrapped it as code review suggests the locking
> already terminally broken and I didn't want to make it first. See added
> comment

Thanks a lot, I will apply your patch and fix the synchronization on 
accessing hidraw_table[] on top of it.

-- 
Jiri Kosina


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbXA2LZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbXA2LZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXA2LZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:25:04 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:41792 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXA2LZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:25:03 -0500
Subject: Re: question on resume()
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200701291206.39637.oneukum@suse.de>
References: <200701291206.39637.oneukum@suse.de>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 22:24:55 +1100
Message-Id: <1170069896.3538.26.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> Hi,
> 
> may a driver call wake_up() while doing resume() ?

I assume you mean waking a userspace process from drivers_resume(). If
so, the answer is no - processes will still be frozen at the point. In
the case of Suspend2, the LRU pages will still not have been read
either, so Suspend2 users would hate you for making hibernation crash
and burn :)

Regards,

Nigel


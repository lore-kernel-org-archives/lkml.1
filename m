Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYCJWNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYCJWNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYCJWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:12:55 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:40194 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYCJWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:12:54 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: locking for tty_wait_until_sent
References: <20080310215325.2b8d33e8@core>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Mar 2008 23:12:51 +0100
In-Reply-To: <20080310215325.2b8d33e8@core>
Message-ID: <87od9m5iu4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Mar 2008 22:06:19.0426 (UTC) FILETIME=[F8004020:01C882FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> This function still depends on the big kernel lock in some cases. Push
> locking into the function ready for removal of the BKL from ioctl call
> paths.

Didn't you forget the .ioctl -> .unlocked_ioctl change?

-Andi

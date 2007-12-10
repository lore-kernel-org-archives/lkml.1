Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbXLJQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbXLJQHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXLJQHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:07:46 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:60563 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbXLJQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:07:45 -0500
Date: Mon, 10 Dec 2007 17:07:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@marvell.com>
Subject: Re: [patch 2.6.24-rc4-mm 0/6] gpiolib updates
Message-ID: <20071210170743.06dc896d@hyperion.delvare>
In-Reply-To: <200712092034.59924.david-b@pacbell.net>
References: <200712092034.59924.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 9 Dec 2007 20:34:59 -0800, David Brownell wrote:
> I'm thinking there should be a non-functional change to
> the gpiolib code:  move it from lib to drivers/gpio.
> 
> My question is whether that's better done by replacing
> the current patches with one new patch, or by a patch
> deleting the current lib/gpiolib.c and adding a new
> drivers/gpio/gpiolib.c ... I think the former would
> make more sense to anyone looking at GIT history.

If gpiolib isn't in git yet, then indeed updating the patch that
creates it before it goes in git sounds more sensible. Let's not make
the git history more complex than needed.

Thanks,
-- 
Jean Delvare

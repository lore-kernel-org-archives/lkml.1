Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYA0QP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYA0QP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYA0QPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:15:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYA0QPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:15:16 -0500
Date: Sun, 27 Jan 2008 17:49:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Race-free kernel.core_pattern
Message-ID: <20080127164919.GA9982@one.firstfloor.org>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru> <20080123105140.3406e25b@lxorguk.ukuu.org.uk> <20080127122634.GA3497@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127122634.GA3497@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, that's the bug.
> 
> Below is companion patch to be applied after BKL removal which fixes it:

Still there are other do_string (and possibly multiple number integer) users 
which are likely buggy in the same way. It's probably better to find some more 
generic mechanism instead of adding a new lock for each of them.

-Andi


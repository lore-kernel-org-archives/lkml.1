Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXKPAWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXKPAWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXKPAW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:22:28 -0500
Received: from gw.goop.org ([64.81.55.164]:59182 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbXKPAW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:22:27 -0500
Message-ID: <473CE2B6.3090304@goop.org>
Date: Thu, 15 Nov 2007 16:22:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm creation/destruction hooks
References: <20071115234648.GA10948@c2.user-mode-linux.org>
In-Reply-To: <20071115234648.GA10948@c2.user-mode-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> The changelog for commit d6dd61c831226f9cd7750885da04d360d6455101 says
> 	arch_dup_mmap, which is called when a new mmap is created at fork
>
> Is there a reason that you're not tracking mm creation in exec?

activate_mm() does that.

    J

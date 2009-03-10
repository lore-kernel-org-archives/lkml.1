Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZCJXa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZCJXa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZCJXas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:30:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49386 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZCJXar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:30:47 -0400
Date: Tue, 10 Mar 2009 23:30:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMAP: watchdog driver fixes.
Message-ID: <20090310233032.GC26045@n2100.arm.linux.org.uk>
References: <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 06:03:50PM +0200, Atal Shargorodsky wrote:
> This patchset reorganizes slightly the code of omap_wdt driver,
> introduces proper management of clocks and
> CONFIG_WATCHDOG_NOWAYOUT + PM support, which was broken.
> Also, inspired by numerous watchdog drivers using this technique, 
> this patchset makes the NOWAYOUT behavior not to be restricted by kernel
> configuration, but to be controlled by a module parameter.

NAK for the entire patch set.  The first four patches severely clash
with my clk API work which is (in theory) queued for the next merge
window.  My patches already eliminate most of the unnecessary clk API
crap in there.

Moreover, your emails show no interaction with either the ARM mailing
lists or the OMAP mailing lists.

Please submit your patches to both the ARM and OMAP mailing lists for
review there.  Thanks.

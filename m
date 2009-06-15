Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZFOI7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZFOI7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZFOI6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:58:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34215 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbZFOI6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:58:45 -0400
Date: Mon, 15 Jun 2009 09:58:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Robert Love <rlove@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
	serial peripheral.
Message-ID: <20090615085836.GA8800@n2100.arm.linux.org.uk>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <20090615085216.GC10822@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615085216.GC10822@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:52:16AM +0200, Pavel Machek wrote:
> > +#if defined(CONFIG_SERIAL_MSM_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> > +# define SUPPORT_SYSRQ
> > +#endif
> 
> SUPPORT_SYSRQ seems to be unused.

It's used in include/linux/serial_core.h to enable the additional sysrq
stuff - but that's something that desperately need to die now that the
additional member is not at the end of the struct (it's buggy as
currently stands).

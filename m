Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXJZPMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXJZPMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbXJZPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:12:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54153 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXJZPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:12:33 -0400
Date: Fri, 26 Oct 2007 16:11:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Message-ID: <20071026151141.GA4321@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071026105125.GA28769@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026105125.GA28769@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 12:51:25PM +0200, Rodolfo Giometti wrote:
> If a socket has been ejected before sleeping, at resume time it
> shouldn't be awaked.

Conversely, if a card has been inserted into an empty slot prior to
resuming, it should be detected.  Removing this check prevents that
happening, which sucks for at least embedded devices.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZFAJbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZFAJbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZFAJbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:31:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42534 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbZFAJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:31:17 -0400
Date: Mon, 1 Jun 2009 10:31:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090601093106.GC11880@n2100.arm.linux.org.uk>
References: <1243846836-14395-1-git-send-email-baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243846836-14395-1-git-send-email-baruch@tkos.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 12:00:36PM +0300, Baruch Siach wrote:
> This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
> is implemented using the gpiolib framework.

Why is this a platform driver rather than an AMBA primecell driver?

There are platforms today which provide the PL061 as an amba primecell
device.

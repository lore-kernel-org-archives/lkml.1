Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZAaMBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZAaMBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAaMBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:01:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55923 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZAaMBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:01:21 -0500
Date: Sat, 31 Jan 2009 12:01:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 02/10] OMAP2/3 clockdomains: combine pwrdm, pwrdm_name into union in struct clockdomain
Message-ID: <20090131120112.GG1394@n2100.arm.linux.org.uk>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024408.27240.32198.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128024408.27240.32198.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:44:11PM -0700, Paul Walmsley wrote:
> struct clockdomain contains a struct powerdomain *pwrdm and const char
> *pwrdm_name.  The pwrdm_name is only used at initialization to look up
> the appropriate pwrdm pointer.  Combining these into a union saves
> about 100 bytes on 3430SDP.  This patch should not cause any change in
> kernel function.

For the same reasons as B1, this would seem to be unsafe.

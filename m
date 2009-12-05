Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbZLEX6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbZLEX6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZLEX6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:58:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41015 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbZLEX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:58:40 -0500
Date: Sat, 5 Dec 2009 23:58:31 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091205235830.GA14475@flint.arm.linux.org.uk>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 07:08:50PM +0000, Al Viro wrote:
> [NOTE: the patch series below is not for merge until ACKed by arch maintainers]

Having spent a while looking at these changes, I don't forsee any
problems with patches 1,2,3,4,5,9.  So that range of patches can
have my:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

If I get some spare time tomorrow, I'll try to test them on hardware,
and check that the page mappings below the minimum address are still
prevented on ARM, but I don't forsee a problem.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbYA0XFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbYA0XFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA0XFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:05:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38584 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbYA0XFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:05:24 -0500
Subject: Re: [PATCH] [9/18] BKL-removal: Use unlocked_ioctl for jfs
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20080127021715.B24FE14D2E@wotan.suse.de>
References: <20080127317.043953000@suse.de>
	 <20080127021715.B24FE14D2E@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 17:05:10 -0600
Message-Id: <1201475110.11997.35.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-27 at 03:17 +0100, Andi Kleen wrote:
> Convert jfs_ioctl over to not use the BKL. The only potential race
> I could see was with two ioctls in parallel changing the flags
> and losing the updates. Use the i_mutex to protect against this.
> 
> Cc: shaggy@austin.ibm.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Added to the jfs git tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center


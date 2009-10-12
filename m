Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZJLJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZJLJIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZJLJIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:08:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZJLJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:08:00 -0400
Date: Mon, 12 Oct 2009 10:07:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nitin Gupta <ngupta@vflare.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
Message-ID: <20091012090710.GA29310@n2100.arm.linux.org.uk>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 02:20:23PM +0530, Nitin Gupta wrote:
> Same problem exists on mips too.

Nice catch.  This logic came from sparc64, so I think you'd want to talk
to davem about it as well.

In the mean time, submitting your fix to the patch system would be great,
thanks.

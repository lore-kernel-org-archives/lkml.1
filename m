Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYK3VXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYK3VXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 16:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK3VXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 16:23:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57359 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYK3VXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 16:23:31 -0500
Date: Sun, 30 Nov 2008 21:23:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [please, revert] Re: [PATCH 11/32] of_platform_driver noise on
	sparce
Message-ID: <20081130212329.GF28946@ZenIV.linux.org.uk>
References: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk> <20081126.010541.158438052.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126.010541.158438052.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 01:05:41AM -0800, David Miller wrote:
> There's tons of sparc specific drivers not handled here.
> For example, drivers/scsi/sun_esp.c, drivers/scsi/qlogicpti.c,
> and on and on and on.
> 
> In fact there are more sparc specific drivers using
> of_platform_driver under drivers/ thans powerpc :)
> 
> I don't think I want to do this for now, sorry Al.

Argh...  Looks like that got picked despite the NAK ;-/

Linus, could you revert commit e669dae6141ff97d3c7566207f5de3b487dcf837?
NAKed by maintainer, so...

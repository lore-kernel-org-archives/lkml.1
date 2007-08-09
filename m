Return-Path: <linux-kernel-owner+w=401wt.eu-S940625AbXHIOkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940625AbXHIOkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935593AbXHIOkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:40:01 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:57820 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429AbXHIOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:40:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 10:40:00 EDT
From: Phil Moors <pmoors@speakeasy.net>
Date: Thu, 9 Aug 2007 10:13:33 -0400
To: linux-kernel@vger.kernel.org
Subject: EDAC k8 MC1: unknown syndrome
Message-ID: <20070809141333.GA10188@speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting these in the log:

EDAC k8 MC1: unknown syndrome 0x9391 - possible error reporting race
EDAC MC1: CE - no information available: k8_edac

>From looking about, I think that MC1 is memory controller 1 (on 2nd cpu)
and that CE is about error correction in ECC.

But is the error really reporting a DIMM problem or a race condition in
the kernel code handling ECC?

Thanks,
Phil

